---
description: GitHub PRのdiffとコメントを取得して他者のコードをレビューする
argument-hint: <PR URL | PR番号>
# gh apiはallowed-toolsに入れない（ユーザーがacceptする）
allowed-tools: Read, Read(//tmp/*), Glob, Grep, Bash(jq *), Bash(gh pr view *), Bash(gh pr diff *), Bash(mktemp *), Bash(git branch *), Bash(git status *), Skill(review-common)
---

# PR コードレビュー

**対象**: $ARGUMENTS

`git branch --show-current` で対象PRのブランチにいるか確認し、違えばcheckoutを促す（自動ではしない）。

## 手順

0. **OWNER/REPO/NUMBER解決** — PR URLならそこから抽出。番号のみ・未指定なら `gh pr view [NUMBER] --json url,number` で取得
1. `gh pr view NUMBER --json title,body,author,state,baseRefName,headRefName,url` でPR情報取得
2. `gh pr diff NUMBER` は1回だけ実行し `mktemp` のtempファイルに保存する。以降はこのファイルを参照し、`gh pr diff` を再度呼ばない
3. `gh api repos/OWNER/REPO/pulls/NUMBER/comments` で行指定コメント、`.../issues/NUMBER/comments` で一般コメントを取得

既にコメントがある行は重複を避け、未評価の差分を主な対象にする。未解決スレッドや著者の返答があればそのやり取りを踏まえて深掘りし、総評（Request Changes/Approve）があれば懸念点・承認理由を踏まえる。

diffで変更箇所を把握した後は、関数・型の定義、呼び出し箇所、diffに映らない周辺コードをローカルファイルの `Read`/`Grep` で確認する。追加情報が必要でも `gh pr diff` は呼ばず、tempファイルかローカルファイルで対応する。

## 方針

`Skill(review-common)` の基本姿勢に従う。加えてPRの説明・意図を踏まえてdiffを確認する。

## 出力

`Skill(review-common)` の出力フォーマット（良い点 → 指摘事項 → サマリー、重要度基準はコードレビュー共通のもの）に、既存コメントがあれば「既存コメントのサマリー」を挟む。
