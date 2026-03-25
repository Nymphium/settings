---
targets:
  - '*'
---
# PRコメントの修正・Resolve・Push

現在のブランチのPRに付いたレビューコメントをすべて対応します。

## 手順

1. **PRの特定**
   まず現在のブランチに紐づくPR番号を取得する：
```
   gh pr view --json number,title,url
```

2. **未解決コメントの取得**
   PRのレビューコメント（スレッド）をすべて取得する：
```
   gh api graphql -f query='
   {
     repository(owner: OWNER, name: REPO) {
       pullRequest(number: PR_NUMBER) {
         reviewThreads(first: 50) {
           nodes {
             id
             isResolved
             comments(first: 10) {
               nodes {
                 body
                 path
                 line
                 originalLine
                 diffHunk
               }
             }
           }
         }
       }
     }
   }'
```
   ※ owner/repoは `gh repo view --json owner,name` で取得する。

3. **未解決スレッドの修正**
   `isResolved: false` のスレッドについて：
   - コメントの内容（`body`）、対象ファイル（`path`）、行番号（`line`）を確認する
   - 指摘された内容を理解して該当コードを修正する
   - 修正内容をコミットメッセージに含めて記録する

4. **コミット**
   修正をまとめてコミットする：
```
   git add -A
   git commit -m "fix: address PR review comments"
```

5. **コメントスレッドをResolve**
   修正済みのスレッドを1つずつresolveする：
```
   gh api graphql -f query='
   mutation {
     resolveReviewThread(input: {threadId: "THREAD_ID"}) {
       thread { isResolved }
     }
   }'
```

6. **Push**
```
   git push
```

7. **完了報告**
   対応したコメントの一覧と修正内容をサマリーとして表示する。

## 注意事項
- コメントの意図が不明な場合は修正前に確認を求める
- 複数のスレッドに関連する修正はまとめて1コミットにする
- resolveは修正が完了したスレッドのみ行い、議論中のものはスキップする
