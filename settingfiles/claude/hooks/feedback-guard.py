#!/usr/bin/env python3
"""PreToolUse hook: stop a tool call that violates a settled feedback rule.

Injecting the rule into context makes it visible; this makes it binding. Every
match is written to the violation log so the Stop hook can refuse to end the
turn while something is still unaddressed.
"""
#
# Design source: https://zenn.dev/nozomi720/articles/claude_code_hooks_feedback
# ("Claude Code Hooks実装ガイド" by nozomi720). The article publishes the
# architecture and short excerpts, not the scripts; this is a
# reimplementation, but the severity table, the rule frontmatter format and
# the retry cap follow the excerpts it shows.


import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import feedback_lib as fb  # noqa: E402

EDIT_TOOLS = ("Edit", "Write", "MultiEdit", "NotebookEdit")


def evaluate(tool_name, tool_input, cwd):
    """All rule violations this tool call would commit."""
    hits = []
    command = ""
    if isinstance(tool_input, dict):
        command = tool_input.get("command") or ""
    paths = fb.edited_paths(tool_name, tool_input)

    for rule in fb.list_rules():
        for entry in rule["enforce"]:
            event = str(entry.get("event") or "")

            if event == "pre_bash" and tool_name == "Bash":
                if fb.matches_when(entry.get("when"), command):
                    hits.append((rule, entry, command))

            elif event == "pre_edit" and tool_name in EDIT_TOOLS:
                for path in paths:
                    if not fb.path_rule_matches(entry, path, cwd):
                        continue
                    sibling = entry.get("absent_sibling")
                    if sibling:
                        expected = fb.sibling_for(str(sibling), path)
                        if os.path.exists(expected):
                            continue
                        hits.append((rule, entry, "{} (missing {})".format(path, expected)))
                    else:
                        hits.append((rule, entry, path))
    return hits


def main():
    raw = sys.stdin.read()
    data = json.loads(raw) if raw.strip() else {}

    tool_name = data.get("tool_name") or ""
    tool_input = data.get("tool_input") or {}
    cwd = data.get("cwd") or os.getcwd()
    session_id = data.get("session_id") or ""

    hits = evaluate(tool_name, tool_input, cwd)
    if not hits:
        return 0

    decision = None
    reasons = []
    for rule, entry, detail in hits:
        severity = fb.resolve_severity(
            rule["count"], entry.get("severity"), entry.get("event")
        )
        fb.record_violation(session_id, rule, entry, severity, detail)
        message = entry.get("message") or rule["description"] or rule["name"]
        reasons.append("[{}/{}] {}".format(rule["name"], severity, message))
        if severity == "deny":
            decision = "deny"
        elif severity in ("ask", "block") and decision != "deny":
            decision = "escalate"

    reason = "\n".join(reasons)
    if decision is None:  # warn only: let the call through, but say it out loud
        print(
            json.dumps(
                {
                    "hookSpecificOutput": {"hookEventName": "PreToolUse"},
                    "additionalContext": "Feedback warning:\n" + reason,
                },
                ensure_ascii=False,
            )
        )
        return 0

    print(
        json.dumps(
            {
                "hookSpecificOutput": {
                    "hookEventName": "PreToolUse",
                    "permissionDecision": decision,
                    "permissionDecisionReason": reason,
                }
            },
            ensure_ascii=False,
        )
    )
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main() or 0)
    except Exception as exc:  # a broken hook must not wedge the session
        sys.stderr.write("[feedback-guard] internal error (ignored): {}\n".format(exc))
        sys.exit(0)
