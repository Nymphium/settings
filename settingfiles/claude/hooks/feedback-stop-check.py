#!/usr/bin/env python3
"""Stop hook: refuse to end the turn while feedback is still unaddressed.

Two sources of blockers: violations the PreToolUse guard recorded during this
session, and `event: stop_check` rules evaluated against the working tree (for
rules that are only checkable once the edits exist).

The retry counter is the safety valve — after MAX_ATTEMPTS consecutive blocks
the hook gives up and lets the turn end, because a hook that can loop forever
is worse than a rule that slips through once.
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

MAX_ATTEMPTS = 3
BLOCKING = ("ask", "block", "deny")


def stop_check_issues(cwd):
    """Rules that inspect the working tree rather than a single tool call."""
    issues = []
    rules = [r for r in fb.list_rules() if any(
        str(e.get("event") or "") == "stop_check" for e in r["enforce"]
    )]
    if not rules:
        return issues

    changed = fb.changed_files(cwd)
    if not changed:
        return issues

    for rule in rules:
        for entry in rule["enforce"]:
            if str(entry.get("event") or "") != "stop_check":
                continue
            severity = fb.resolve_severity(
                rule["count"], entry.get("severity"), "stop_check"
            )
            if severity not in BLOCKING:
                continue
            for path in changed:
                if not fb.path_rule_matches(entry, path, cwd):
                    continue
                sibling = entry.get("absent_sibling")
                if sibling and os.path.exists(fb.sibling_for(str(sibling), path)):
                    continue
                issues.append(
                    "[{}/{}] {} ({})".format(
                        rule["name"],
                        severity,
                        entry.get("message") or rule["description"] or rule["name"],
                        path,
                    )
                )
    return issues


def main():
    raw = sys.stdin.read()
    data = json.loads(raw) if raw.strip() else {}

    # Already inside a stop-hook continuation: never block twice in a row.
    if data.get("stop_hook_active"):
        return 0

    session_id = data.get("session_id") or ""
    cwd = data.get("cwd") or os.getcwd()

    issues = [
        "[{}/{}] {} ({})".format(
            record.get("rule"),
            record.get("severity"),
            record.get("message"),
            record.get("detail"),
        )
        for record in fb.open_violations(session_id)
        if record.get("severity") in BLOCKING
    ]
    issues.extend(stop_check_issues(cwd))

    if not issues:
        fb.clear_session(session_id)
        return 0

    attempts = fb.bump_attempts(session_id)
    if attempts > MAX_ATTEMPTS:
        sys.stderr.write(
            "[feedback-stop-check] blocked {} times in a row; giving up.\n".format(
                MAX_ATTEMPTS
            )
        )
        fb.clear_session(session_id)
        return 0

    fb.mark_surfaced(session_id)
    sys.stderr.write(
        "Unaddressed feedback from this session (attempt {}/{}):\n{}\n"
        "Fix these before finishing, or say explicitly why the rule does not apply.\n".format(
            attempts, MAX_ATTEMPTS, "\n".join("- " + i for i in issues)
        )
    )
    return 2


if __name__ == "__main__":
    try:
        sys.exit(main() or 0)
    except Exception as exc:  # a hook must never trap the user in a loop
        sys.stderr.write("[feedback-stop-check] internal error (ignored): {}\n".format(exc))
        sys.exit(0)
