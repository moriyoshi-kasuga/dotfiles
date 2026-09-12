---
description: 指定されたコード・ファイルをレビューする。ファイルの読み取りのみ行い、コードは変更しない。PRのレビューは /pr-review を使うこと。
argument-hint: <ファイルパス | git diff | コミットハッシュ | 対象の説明>
allowed-tools: Read, Glob, Grep, Bash(git diff *), Bash(git log *), Bash(git show *), Skill(review-common)
---

# コードレビュー

**対象**: $ARGUMENTS（ファイルパスならそのファイル、`git diff`/`HEAD`等なら差分、未指定なら `git diff HEAD`）

コードの変更は行わない。読み取りのみで、それ以外の基本姿勢・レビュー観点（可読性はコメントの過不足も見る）・出力フォーマット・重要度基準は `Skill(review-common)` に従う。
