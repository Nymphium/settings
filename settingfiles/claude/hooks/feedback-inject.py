#!/usr/bin/env python3
"""UserPromptSubmit hook: put the settled feedback rules in front of Claude.

Only rules the human has had to repeat at least THRESHOLD times are injected —
below that the rule is still advice, and spending context on it every turn is
not worth it.
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

THRESHOLD = 3


def build_context(rules):
    lines = [
        "## Standing feedback (already given, do not make the user repeat it)",
        "",
    ]
    for rule in rules:
        severity = fb.resolve_severity(rule["count"])
        lines.append(
            "- **{name}** (repeated {count}x, enforcement: {severity}): {description}".format(
                name=rule["name"],
                count=rule["count"],
                severity=severity,
                description=rule["description"] or "(no description)",
            )
        )
        for entry in rule["enforce"]:
            message = entry.get("message")
            if message:
                lines.append("    - {}".format(message))
    lines.append("")
    lines.append(
        "Full text of each rule: {}/<name>.md".format(fb.FEEDBACK_DIR)
    )
    return "\n".join(lines)


def main():
    raw = sys.stdin.read()
    json.loads(raw) if raw.strip() else {}  # validate, fields unused for now

    rules = [r for r in fb.list_rules() if int(r.get("count") or 0) >= THRESHOLD]
    if not rules:
        return 0

    print(
        json.dumps(
            {
                "hookSpecificOutput": {"hookEventName": "UserPromptSubmit"},
                "additionalContext": build_context(rules),
            },
            ensure_ascii=False,
        )
    )
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main() or 0)
    except Exception as exc:  # never block work because of a hook bug
        sys.stderr.write("[feedback-inject] internal error (ignored): {}\n".format(exc))
        sys.exit(0)
