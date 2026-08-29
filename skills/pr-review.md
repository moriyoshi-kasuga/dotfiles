---
description: GitHub PRのdiffとコメントを取得して他者のコードをレビューする
argument-hint: <PR URL | PR番号>
# gh apiはallowed-toolsに入れない（ユーザーがacceptする）
allowed-tools: Read, Read(//tmp/*), Glob, Grep, Bash(jq *), Bash(gh pr view *), Bash(gh pr diff *), Bash(mktemp *), Bash(git branch *), Bash(git status *)
---

# PR コードレビュー

**対象**: $ARGUMENTS

## 前提確認

レビュー開始前に `git branch --show-current` でカレントブランチを確認する。
対象PRのブランチにいない場合は、その旨をユーザーに伝えてチェックアウトを促す（自動でcheckoutしない）。

## 手順

### 0. OWNER / REPO / NUMBER の解決

引数のパターンで分岐する：

- **PR URL** (`https://github.com/OWNER/REPO/pull/NUMBER`)
  → URL から OWNER・REPO・NUMBER を直接抽出する。

- **PR番号のみ**
  ```bash
  gh pr view NUMBER --json url,number
  ```
  → 返却された `url` から OWNER・REPO を抽出し、NUMBER は引数をそのまま使う。

- **未指定（現在のブランチ）**
  ```bash
  gh pr view --json url,number
  ```
  → `url` から OWNER・REPO を、`number` から NUMBER を取得する。

### 1. PR情報取得

```bash
gh pr view NUMBER --json title,body,author,state,baseRefName,headRefName,url
```

### 2. 差分取得（tempファイルに保存）

diff は1回だけ取得してtempファイルに保存し、以降はそのファイルを参照する。

```bash
DIFF_FILE=$(mktemp /tmp/pr-diff-NUMBER-XXXXXX.diff)
gh pr diff NUMBER > "$DIFF_FILE"
echo $DIFF_FILE
```

以降 `$DIFF_FILE` を Read / Grep で参照し、`gh pr diff` を再度呼ばない。

### 3. レビューコメント取得（行指定コメント）

```bash
gh api repos/OWNER/REPO/pulls/NUMBER/comments | jq 'map({username: .user.login,id,in_reply_to_id,path,subject_type,original_line,body})'
```

### 4. 一般コメント取得（会話・総評）

```bash
gh api repos/OWNER/REPO/issues/NUMBER/comments | jq 'map({username: .user.login,body})'
```

## コメント情報の活用方針

取得したコメントをもとに以下を判断する：

- **既評価箇所の除外** — すでにコメントがついている行・ロジックは重複を避け、言及するとしても「この議論に加えて」とする
- **未評価箇所の優先** — コメントのない差分を主なレビュー対象とする
- **スレッドの深掘り** — 未解決スレッドや提案に対する著者の返答がある場合はそのやり取りを踏まえてさらなる観点を示す
- **レビュー総評の考慮** — Request Changes / Approve の総評がある場合はその懸念点と承認理由を把握した上でレビューを行う

## レビュー観点

- **正確性** — ロジックのバグ・エッジケース・境界値の漏れ
- **安全性** — インジェクション・認証漏れ・機密情報の露出など OWASP Top 10
- **可読性** — 命名・関数の長さ・複雑度
- **保守性** — 重複・責務の分離・変更容易性
- **パフォーマンス** — 不要な計算・N+1・メモリリーク

## ローカルファイルの活用

差分で変更箇所を把握した後の深掘りはローカルファイルを直接参照する。

- **関数・型の定義確認** — Read / Grep でローカルファイルを検索する
- **呼び出し箇所の調査** — Grep で該当シンボルの参照元を洗う
- **周辺コンテキストの把握** — diff に映らない既存コードは Read で読む
- **`gh pr diff` の再呼び出し禁止** — 追加情報が必要な場合も tempファイル（`$DIFF_FILE`）か Read/Grep で対応する

## 方針

- PRの説明・意図を踏まえてdiffを確認する
- 明示的に求められない限りコードを書き直さない
- 指摘は問題の説明と改善提案をセットで行う
- スタイル・好みの問題と実際の問題を区別する

## 出力形式

### 良い点

[優れているコード・設計・アプローチを列挙]

### 既存コメントのサマリー（任意）

既存コメントが存在する場合、未解決スレッドや重要な議論をまとめる。

### 指摘事項

各指摘は以下の形式で記載する：

- **[重要度: 高/中/低]** `ファイル名:行番号` — 問題の説明 → 改善提案

重要度の基準：

- **高**: バグ・セキュリティ問題・データ損失リスク
- **中**: パフォーマンス問題・保守性の低下
- **低**: 可読性・スタイル・軽微な改善

### サマリー

[全体的な評価と、優先して対応すべき点]
