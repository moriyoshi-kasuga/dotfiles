---
description: 既存実装を「参考」に留め、後方互換性・破壊的変更を一切気にせず、ゼロベースで最良の設計を考えて完全に書き直す。まず rewrite 設計を提案し、accept されたら全面的にリライトする。対象言語を判定し、Rust / TypeScript の設計方針を適用する（対応言語がなければ共通思想のみで進める）。
argument-hint: <ファイルパス | 対象箇所の説明>
# Edit / Write は意図的に入れない: フェーズ1（accept 前）の誤書き込みを防ぎ、最初の書き込み時の許可プロンプトが accept の二重ゲートになる
allowed-tools: Read, Glob, Grep, Bash(git diff *), Bash(git status *), Bash(git log *), Bash(cargo check *), Bash(cargo test *), Bash(cargo clippy *), Bash(cargo fmt *), Bash(npm run lint*), Bash(npm run check*), Bash(npm run format*), Bash(npm run test*), Bash(npm test), Bash(npx tsc *), Bash(deno run lint*), Bash(deno run check*), Bash(deno run format*), Bash(deno test *)
---

# 完全リライト

**対象**: $ARGUMENTS

> - **ファイルパス・箇所指定**: そのファイル・箇所を対象にする
> - **未指定**: 直前の作業対象または `git diff HEAD` の変更を対象にする

## このスキルの位置づけ

| スキル | 機能変更 | 既存設計の扱い | 主な用途 |
|---|---|---|---|
| `refactor` | 行わない | 維持する | 動いているコードの内部構造を安全に整理 |
| `brushup` | 行ってよい | 意図を最優先で尊重 | 荒削りな実装を全面的に磨き上げる |
| **`rewrite`** | **大胆に行う** | **参考に留める（尊重しない）** | ゼロベースで最良の設計に完全に書き直す |

`brushup` が「動く → 良い」を実装者の意図の延長線上で目指すのに対し、
`rewrite` は **「既存実装はあくまで参考資料」** と割り切り、より良い設計を独自に組み立てて全面的に書き直す。

## 構成

このスキルは対象言語ごとに設計方針を切り替える。

| ファイル | 役割 |
|---|---|
| `common.md` | 言語非依存の哲学・実行手順・出力形式。**常に適用する** |
| `rust.md` | Rust 固有の設計方針。対象が Rust の場合に追加で適用する |
| `typescript.md` | TypeScript 固有の設計方針。対象が TypeScript の場合に追加で適用する |

対応する言語ファイルがない場合（未対応言語、または言語を判定できない場合）は `common.md` の内容のみで進める。

## 実行手順

1. **共通思想の読み込み** — まず `common.md` を `Read` し、哲学・実行手順・出力形式を把握する
2. **対象言語の判定** — 拡張子・プロジェクト設定から対象言語を判定する
   - `.rs` / `Cargo.toml` の存在 → Rust
   - `.ts` / `.tsx` / `tsconfig.json` の存在 → TypeScript
   - それ以外・判定できない → 対応する言語ファイルなし
3. **言語別方針の読み込み** — 判定した言語に対応するファイルがあれば `Read` し、`common.md` の内容に統合して適用する
   - Rust → `rust.md`
   - TypeScript → `typescript.md`
   - 対応ファイルなし → `common.md` のみで進める
4. **`common.md` の実行手順（フェーズ1 / フェーズ2）に従って進める** — 設計の指針・検証コマンドは、読み込んだ言語ファイルの内容を優先し、`common.md` の言語非依存の指針で補う

出力形式は常に `common.md` の「出力形式」に従う。
