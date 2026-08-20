# feedback rules

`~/.claude/feedback/*.md` に置いたルールを 3 つの hook が読む。

| hook | イベント | 役割 |
|---|---|---|
| `feedback-inject.py` | UserPromptSubmit | `count >= 3` のルールを毎ターン文脈に注入する |
| `feedback-guard.py` | PreToolUse (Bash/Edit/Write/MultiEdit) | 違反するツール呼び出しを escalate / deny する |
| `feedback-stop-check.py` | Stop | 未対応の違反が残っているうちはターンを終わらせない（最大 3 回で打ち切り） |

## count と強制力

`count` は「同じ指摘を何回繰り返したか」。**hook は自動で増やさない**。重み付けは人間だけが決める。

| count | pre_bash / pre_edit | stop_check |
|---|---|---|
| >= 5 | deny | deny |
| 3-4 | escalate | block |
| 1-2 | warn（通すが Claude に警告を渡す） | 何もしない |

`severity` を enforce 項目に明示すれば count より優先される（`warn` / `ask`(=escalate) / `block` / `deny`）。

## ルールファイルの書式

```markdown
---
name: tdd
description: 実装前にテストを書く
type: feedback
count: 3
enforce:
  # 実装ファイルを書く前にテストが無ければ止める
  - event: pre_edit
    path: '**/*.go'
    exclude: '**/*_test.go'
    absent_sibling: '{stem}_test.go'
    message: 'TDD: 先にテスト(Red)を書くこと。'
  # テストの手動実行を禁じる
  - event: pre_bash
    when: '(go test|pytest|pnpm test)'
    message: 'テストは hook に任せ、Bash で手動実行しない。'
    severity: deny
  # テスト無しの実装を残したままターンを終わらせない
  - event: stop_check
    path: '**/*.go'
    exclude: '**/*_test.go'
    absent_sibling: '{stem}_test.go'
    message: 'テストの無い実装を残して終了しないこと。'
---

**Why:** ...
**How to apply:** ...
```

- `event`: `pre_bash` / `pre_edit` / `stop_check`
- `when`: bash コマンドに対する正規表現（`pre_bash`）
- `path` / `exclude`: 対象ファイルの glob（`**/` 始まりはルート直下にもマッチする）
- `absent_sibling`: 隣にあるべきファイル。`{stem}` `{name}` `{ext}` `{dir}` が使える。**存在しなければ違反**
- `stop_check` は `git status --porcelain` の変更ファイルだけを見る

## 状態ファイル

- `.violations.jsonl` — guard が記録した違反
- `.state.json` — セッションごとの surfaced 時刻と連続ブロック回数

どちらもリポジトリ管理外（`~/.claude/feedback/` に直接置かれる）。ルール `.md` だけが settings リポジトリからの symlink。

## 出典

設計元: [{0}]({0})（nozomi720「Claude Code Hooks実装ガイド」）。記事はアーキテクチャと抜粋のみを公開しており、hook スクリプトは本リポジトリでの再実装。ただし severity 表・ルール frontmatter の書式・リトライ上限は記事の抜粋に従っている。
