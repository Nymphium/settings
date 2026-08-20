"""Shared helpers for the feedback hooks.

Rules live as Markdown files with YAML frontmatter in ~/.claude/feedback/.
Each rule carries a `count` (how many times the human had to repeat the
feedback) and optional `enforce` entries that make it machine-checkable.

Nothing here may raise into the caller: a hook that crashes is worse than a
missed detection, so every entry point wraps its work and exits 0 on error.
"""
#
# Design source: https://zenn.dev/nozomi720/articles/claude_code_hooks_feedback
# ("Claude Code Hooks実装ガイド" by nozomi720). The article publishes the
# architecture and short excerpts, not the scripts; this is a
# reimplementation, but the severity table, the rule frontmatter format and
# the retry cap follow the excerpts it shows.


import json
import os
import re
import time

FEEDBACK_DIR = os.environ.get(
    "CLAUDE_FEEDBACK_DIR", os.path.join(os.path.expanduser("~"), ".claude", "feedback")
)
VIOLATIONS_PATH = os.path.join(FEEDBACK_DIR, ".violations.jsonl")
STATE_PATH = os.path.join(FEEDBACK_DIR, ".state.json")

# Only the human bumps `count`; the hooks never do. Enforcement strength is a
# judgement about how much the repetition cost, which a script cannot make.
SEVERITIES = ("warn", "ask", "block", "deny")


def resolve_severity(count, explicit=None, event=None):
    """Severity for a rule: explicit wins, otherwise derived from `count`."""
    if explicit:
        normalized = str(explicit).strip().lower()
        if normalized == "escalate":
            return "ask"
        if normalized in SEVERITIES:
            return normalized
    try:
        count = int(count)
    except (TypeError, ValueError):
        count = 0
    if count >= 5:
        return "deny"
    if count >= 3:
        return "block" if event == "stop_check" else "ask"
    return "warn"


# --- frontmatter -----------------------------------------------------------


def _coerce(value):
    value = value.strip()
    if len(value) >= 2 and value[0] == value[-1] and value[0] in ("'", '"'):
        return value[1:-1]
    if re.fullmatch(r"-?\d+", value):
        return int(value)
    if value.lower() in ("true", "false"):
        return value.lower() == "true"
    return value


def _parse_frontmatter(text):
    """Parse the YAML subset the rule files use.

    PyYAML is used when importable; the fallback understands scalars plus one
    level of `key:` / `  - key: value` lists, which is all the format needs.
    """
    try:
        import yaml  # type: ignore

        return yaml.safe_load(text) or {}
    except Exception:
        pass

    data = {}
    current_list = None
    current_item = None
    for raw in text.splitlines():
        if not raw.strip() or raw.lstrip().startswith("#"):
            continue
        indent = len(raw) - len(raw.lstrip())
        line = raw.strip()

        if indent == 0:
            current_list = None
            current_item = None
            if ":" not in line:
                continue
            key, _, value = line.partition(":")
            key = key.strip()
            if value.strip() == "":
                current_list = []
                data[key] = current_list
            else:
                data[key] = _coerce(value)
            continue

        if current_list is None:
            continue
        if line.startswith("- "):
            current_item = {}
            current_list.append(current_item)
            line = line[2:].strip()
            if not line:
                continue
        if current_item is None or ":" not in line:
            continue
        key, _, value = line.partition(":")
        current_item[key.strip()] = _coerce(value)
    return data


def list_rules():
    """All rule files, newest-count first. Unreadable files are skipped."""
    rules = []
    try:
        names = sorted(os.listdir(FEEDBACK_DIR))
    except OSError:
        return rules

    for name in names:
        if not name.endswith(".md") or name.startswith("."):
            continue
        path = os.path.join(FEEDBACK_DIR, name)
        try:
            with open(path, encoding="utf-8") as handle:
                text = handle.read()
        except OSError:
            continue

        # Frontmatter is what makes a file a rule; plain notes (README and
        # friends) live in the same directory and must not be picked up.
        if not text.startswith("---"):
            continue
        parts = text.split("---", 2)
        if len(parts) < 3:
            continue
        meta = _parse_frontmatter(parts[1]) or {}
        body = parts[2]

        enforce = meta.get("enforce") or []
        if not isinstance(enforce, list):
            enforce = []
        rules.append(
            {
                "path": path,
                "name": str(meta.get("name") or os.path.splitext(name)[0]),
                "description": str(meta.get("description") or "").strip(),
                "count": meta.get("count", 0),
                "enforce": [e for e in enforce if isinstance(e, dict)],
                "body": body.strip(),
            }
        )
    rules.sort(key=lambda r: (-int(r["count"] or 0), r["name"]))
    return rules


# --- violation log ---------------------------------------------------------


def record_violation(session_id, rule, entry, severity, detail):
    os.makedirs(FEEDBACK_DIR, exist_ok=True)
    record = {
        "ts": time.time(),
        "session_id": session_id or "",
        "rule": rule.get("name", ""),
        "event": entry.get("event", ""),
        "severity": severity,
        "message": entry.get("message") or rule.get("description") or rule.get("name"),
        "detail": detail,
    }
    with open(VIOLATIONS_PATH, "a", encoding="utf-8") as handle:
        handle.write(json.dumps(record, ensure_ascii=False) + "\n")
    return record


def _read_state():
    try:
        with open(STATE_PATH, encoding="utf-8") as handle:
            return json.load(handle)
    except (OSError, ValueError):
        return {}


def _write_state(state):
    os.makedirs(FEEDBACK_DIR, exist_ok=True)
    tmp = STATE_PATH + ".tmp"
    with open(tmp, "w", encoding="utf-8") as handle:
        json.dump(state, handle, ensure_ascii=False)
    os.replace(tmp, STATE_PATH)


def open_violations(session_id):
    """Violations of this session that no Stop hook has surfaced yet."""
    session = _read_state().get(session_id or "", {})
    cleared_at = session.get("cleared_at", 0)
    found = []
    try:
        with open(VIOLATIONS_PATH, encoding="utf-8") as handle:
            for line in handle:
                line = line.strip()
                if not line:
                    continue
                try:
                    record = json.loads(line)
                except ValueError:
                    continue
                if record.get("session_id") != session_id:
                    continue
                if record.get("ts", 0) <= cleared_at:
                    continue
                found.append(record)
    except OSError:
        return []
    return found


def bump_attempts(session_id):
    state = _read_state()
    session = state.setdefault(session_id or "", {})
    session["attempts"] = int(session.get("attempts", 0)) + 1
    _write_state(state)
    return session["attempts"]


def clear_session(session_id):
    """Mark everything so far as surfaced and reset the retry counter."""
    state = _read_state()
    state[session_id or ""] = {"cleared_at": time.time(), "attempts": 0}
    _write_state(state)


# --- path matching ---------------------------------------------------------


def match_path(pattern, path, cwd=None):
    """Glob match against the absolute path, the cwd-relative path and the
    basename. `**/x` also matches `x` at the root, which fnmatch alone misses.
    """
    import fnmatch

    if not pattern or not path:
        return False

    candidates = [path]
    if cwd:
        base = cwd.rstrip("/") + "/"
        if path.startswith(base):
            candidates.append(path[len(base) :])
    candidates.append(os.path.basename(path))

    patterns = [pattern]
    if pattern.startswith("**/"):
        patterns.append(pattern[3:])

    for candidate in candidates:
        for pat in patterns:
            if fnmatch.fnmatch(candidate, pat):
                return True
    return False


def path_rule_matches(entry, path, cwd=None):
    """`path` glob minus `exclude`. Without the exclusion a rule like
    `**/*.go` + `{stem}_test.go` flags the test files it just asked for.
    """
    if not match_path(entry.get("path"), path, cwd):
        return False
    excludes = entry.get("exclude")
    if isinstance(excludes, str):
        excludes = [excludes]
    for pattern in excludes or []:
        if match_path(pattern, path, cwd):
            return False
    return True


def sibling_for(template, path):
    """Resolve a sibling template like `{stem}_test.go` next to `path`."""
    directory = os.path.dirname(os.path.abspath(path))
    name = os.path.basename(path)
    stem, ext = os.path.splitext(name)
    resolved = template.format(stem=stem, name=name, ext=ext, dir=directory)
    if os.path.isabs(resolved):
        return resolved
    return os.path.normpath(os.path.join(directory, resolved))


def matches_when(pattern, text):
    if not pattern:
        return False
    try:
        return re.search(pattern, text or "") is not None
    except re.error:
        return False


def edited_paths(tool_name, tool_input):
    """File paths a tool call is about to touch."""
    if not isinstance(tool_input, dict):
        return []
    paths = []
    for key in ("file_path", "path", "notebook_path"):
        value = tool_input.get(key)
        if isinstance(value, str) and value:
            paths.append(value)
    edits = tool_input.get("edits")
    if isinstance(edits, list):
        for edit in edits:
            if isinstance(edit, dict) and isinstance(edit.get("file_path"), str):
                paths.append(edit["file_path"])
    return paths


def mark_surfaced(session_id):
    """Violations up to now have been reported; keep the retry counter."""
    state = _read_state()
    session = state.setdefault(session_id or "", {})
    session["cleared_at"] = time.time()
    _write_state(state)


def changed_files(cwd):
    """Working-tree changes, as absolute paths. Empty outside a repo."""
    import subprocess

    try:
        out = subprocess.run(
            ["git", "status", "--porcelain"],
            cwd=cwd or None,
            stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL,
            timeout=5,
        ).stdout.decode("utf-8", "replace")
    except Exception:
        return []

    paths = []
    for line in out.splitlines():
        if len(line) < 4:
            continue
        entry = line[3:].strip()
        if " -> " in entry:  # rename: take the destination
            entry = entry.split(" -> ", 1)[1]
        entry = entry.strip('"')
        paths.append(os.path.normpath(os.path.join(cwd or ".", entry)))
    return paths
