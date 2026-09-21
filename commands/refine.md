---
description: 設計思想（責務分割・不変条件・依存の向き）は保ったまま、公開APIの使い勝手（シグネチャ・引数・返り値・エラー型・命名・標準トレイト実装・モジュール公開経路）を改善する。破壊的変更は許容し、利用箇所は追従修正する。rewrite のようなゼロベース再設計でも、brushup のような非公開実装限定の磨き上げでもない中間。まず refine 設計を提案し、accept されたら実行する。
argument-hint: <ファイルパス | 対象箇所の説明>
# Edit / Write は意図的に入れない: フェーズ1（accept 前）の誤書き込みを防ぎ、最初の書き込み時の許可プロンプトが accept の二重ゲートになる
allowed-tools: Read, Glob, Grep, Bash(git diff *), Bash(git status *), Bash(git log *), Bash(cargo check *), Bash(cargo test *), Bash(cargo clippy *), Bash(cargo fmt *), Bash(cargo doc *), Skill(rust-coder)
---

# 公開APIの洗練（Rust）

**対象**: $ARGUMENTS

`Skill(rust-coder)` の提案フェーズ共通ルールに従う。**設計思想は正しい。触り心地だけが悪い。** 責務分割・不変条件・依存の向き・同期非同期や所有借用の基本方針は変えない。使いにくさは宣言だけでは分からないので、必ず `Grep` で呼び出し側の実コード（繰り返す変換・取り違えやすい引数・毎回の定型処理）を調べてから診断する。後方互換のために使いにくさを温存せず、壊れる利用箇所はこちらで追従するが、ついでの再設計はしない。内部実装は公開面の変更に必要な範囲だけ触る。

診断の結果、責務分割自体が原因なら `/rewrite` を、内部実装の遅さ・読みにくさが原因なら `/brushup` を勧めて中断する。

## 使いにくさの観点

呼び出し側の実コードに該当するものだけ扱う。引数（境界を緩めて変換を消せないか、bool・同型連続引数を型で表現できないか、builder/option structが要るか、ジェネリクスの入れすぎで型推論やdyn互換性を損なっていないか）、返り値（中間Vecの代わりにIteratorを返せないか、無名タプルを名前付きにできないか、`Option<Result>`と`Result<Option>`の順序）、エラー（呼び出し側が分岐したい単位でvariantを切れているか、ライブラリはthiserror・アプリはanyhow）、命名（Rust API Guidelinesの`as_`/`to_`/`into_`、iter系、`From`/`TryFrom`/`FromStr`）、標準トレイト実装（deriveで済むものが揃っているか、`Display`/`FromStr`/`Extend`/`Deref`の要否）、発見しやすさ・誤用しにくさ（`pub use`での再エクスポート、実装詳細の漏れ、RAII、typestate）を確認する。

## 出力

**フェーズ1（提案）**: 保つ思想 / 現在の公開API / 使いにくさの診断（`ファイル名:行番号` 根拠）/ 改善後の公開API（保つ思想との対応）/ 呼び出し側Before-After（実際の利用箇所。差が出ない変更は落とす）/ 設計判断ポイント / 破壊的変更と移行方法 / 影響範囲。推奨は「呼び出し側にとって最良」基準。

**フェーズ2（実行）**: 採用方針の復唱 / 変えた公開API / 追従修正 / `Skill(rust-coder)` の検証手順の結果（doctest含む）/ 要確認事項。公開APIを変えると既存docコメントは高確率で嘘になるため必ず点検する。
