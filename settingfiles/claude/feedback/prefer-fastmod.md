---
name: prefer-fastmod
description: 一括置換は sed ではなく fastmod を使う
type: feedback
count: 1
enforce:
  - event: pre_bash
    when: '(^|[;&|]\s*)sed\s+(-i|--in-place)'
    message: 'in-place 置換は sed ではなく fastmod を使うこと。'
---

**Why:** sed の in-place 置換は差分の確認なしにファイルを書き換える。fastmod は対話確認と正規表現の一貫した扱いがある。

**How to apply:** `sed -i` を使いたくなったら `fastmod` に置き換える。読み取り専用の `sed -n` などは対象外。
