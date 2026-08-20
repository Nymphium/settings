---
name: use-rg-and-fd
description: 検索は rg / fd を使う。grep と find は使わない
type: feedback
count: 2
enforce:
  - event: pre_bash
    when: '(^|[;&|]\s*)(grep|find)\s'
    message: 'grep/find ではなく rg/fd を使うこと（CLAUDE.md の恒久ルール）。'
---

**Why:** rg / fd は .gitignore を尊重し、桁違いに速い。grep/find を使われるたびに同じ指摘をしている。

**How to apply:** テキスト検索は `rg`、ファイル名検索は `fd`。パイプ経由の `| grep` も同様に `| rg` にする。

`count` を 3 以上に上げると escalate（実行前に許可を求める）、5 以上で deny（実行そのものを拒否）になる。
