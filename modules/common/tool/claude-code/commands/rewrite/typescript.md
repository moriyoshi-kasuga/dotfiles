# TypeScript 設計方針

`common.md` の共通思想に加えて、TypeScript では以下を適用する。

## 型設計

- 有限なバリアントは判別可能な union（discriminated union）で表現する（`string` / `number` での表現をやめる）
- 網羅性チェックは `switch` の `default` で `never` に代入して担保する
- newtype 相当は branded type（例: `type UserId = string & { readonly __brand: "UserId" }`）で表現し、生の `string` / `number` と誤って混用できないようにする
- 境界（外部入力・API レスポンス・環境変数）は zod / valibot 等のスキーマで parse し、以降は検証済みの型として扱う。`as` によるアサーションで済ませない
- `any` を使わず、型が不明な値は `unknown` として受けてから絞り込む
- ミュータブルであるべきでないデータは `readonly` / `Readonly<T>` で表現する
- リテラル型・`as const` でユニオンを固定し、文字列そのものではなく型で選択肢を表現する

## 公開 API の堅牢性

- `index.ts` などのエントリポイントで公開する型・関数を明示し、内部実装を re-export しない
- 公開関数の引数・戻り値は明示的に型注釈し、推論に頼って意図せず広い型が公開されないようにする
- `strict: true`（`strictNullChecks` / `noImplicitAny` 等を含む）と `noUncheckedIndexedAccess` を前提に設計する
- 必須引数が多い・省略可能な設定が多い構築は builder かオプションオブジェクト（各プロパティを適切に required / optional 区別）を検討する

## エラーハンドリング

- 呼び出し側が握りつぶせない失敗は、例外ではなく戻り値の型（`Result<T, E>` 相当の判別可能な union、または neverthrow 等のライブラリ）で表現することを検討する
- 例外を使う場合は `Error` を継承したドメイン固有のエラークラスを定義し、`catch` 側で型を絞り込めるようにする
- エラーに「何が・なぜ失敗したか」のコンテキスト（`cause` オプション等）を持たせる
- 呼び出し元で握りつぶされた `catch {}` / 空の `catch` ブロックを本番パスから排除する

## 非同期・並行

- `Promise` を返す関数は必ず `await` するか呼び出し元に伝播させ、floating promise（放置された `Promise`）を作らない
- 並行実行は `Promise.all` / `Promise.allSettled` で明示し、直列 `await` の連鎖で偶発的にシリアライズしない
- キャンセルが必要な非同期処理は `AbortController` / `AbortSignal` を公開 API のシグネチャに含める

## イディオム・品質

- `for` ループより配列メソッド（`map` / `filter` / `reduce` / `find` / `some` / `every`）を優先する
- オプショナルチェイニング（`?.`）・null 合体演算子（`??`）で冗長な条件分岐を削る
- 分割代入・スプレッドで意図を明確にする
- ユーティリティ型（`Pick` / `Omit` / `Partial` / `Required` 等）で型の重複定義を避ける
- マジックナンバー・マジック文字列は `const` に切り出す

## コメント（TypeScript 固有）

- 型注釈から読み取れる情報（引数の型・戻り値の型）をコメントで繰り返さない
- 公開 API には TSDoc（`/** ... */`）で目的と契約を記述し、`@param` / `@returns` / `@throws` に絞る
- 型定義自体が自己文書化するよう命名・構造を先に見直し、コメントで補うのは最後の手段にする

## 検証コマンド

`tsc --noEmit`（型チェック）→ lint（`npm run lint` / `deno run lint` 等）→ テスト（`npm test` / `deno test` 等）の順に実行して green にし、最後に format（`npm run format` / `deno run format` 等）を実行する。
