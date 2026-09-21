---
description: grill-me 等で事前に確定した仕様・修正計画を入力とし、その仕様に忠実にRust実装を行う。設計判断は行わず、仕様が目的レベルで曖昧な箇所のみ実装前に質問する。仕様が規定しない実装細部の技術選択は自分で判断する。
argument-hint: <仕様書ファイルパス | 実装対象の説明（未指定なら直前の会話で確定した仕様）>
# Edit / Write を意図的に許可: 仕様は事前に確定済みのため提案フェーズのゲートを設けない（曖昧点は AskUserQuestion で都度確認する）
allowed-tools: Read, Glob, Grep, Edit, Write, Bash(git diff *), Bash(git status *), Bash(git log *), Bash(cargo check *), Bash(cargo test *), Bash(cargo clippy *), Bash(cargo fmt *), AskUserQuestion, Skill(rust-coder)
---

# 仕様準拠実装（Rust）

**対象**: $ARGUMENTS

ファイルパスなら読み込み、説明文ならそのテキスト、未指定なら直前の会話の確定済み仕様を対象にする。確定した仕様がなければ `/grill-me` を先に使うよう伝えて中断する。

**「何を作るか」は所与、決めるのは「Rustとしてどう書くか」だけ。** 要件そのものへの疑義・スコープ外の修正はしない。目的レベル（何を達成すべきか）が曖昧・矛盾している場合のみ `AskUserQuestion` で確認し、振る舞いに影響しない技術選択（内部エラー型、関数分割、命名の細部など）は `Skill(rust-coder)` の設計方針に従って自分で決める。

入出力・振る舞い・エラー条件を箇条書きで復唱してから実装し、既存の命名規約・エラー型の流儀に合わせる。実装中に既存コードの問題に気づいても直さず「要確認」に書く（対応は `/rewrite` `/brushup` `/refine` の領分）。既存コードと矛盾する変更が必要になった場合はそれ自体が仕様の曖昧点なので質問に戻る。

`Skill(rust-coder)` の検証手順でgreenにしたら、確定した仕様・実装内容・自分で決めた技術選択・検証結果・仕様との対応・要確認事項を報告する。
