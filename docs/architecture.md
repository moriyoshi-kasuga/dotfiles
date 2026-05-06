# Architecture

このドキュメントは `lib/` の設計とモジュールシステム全体の動作を説明します。
読者対象は開発者および AI エージェントです。

---

## 概要

```
flake.nix
  └─ mkPlatform (lib/mkPlatform.nix)
       └─ mkPlatformInner (lib/mkPlatformInner.nix) × n hosts
            ├─ resolveModules (lib/resolveModules.nix)
            │    └─ modules/**/*.nix  ← mkModule で定義された各モジュール
            └─ nixpkgs.lib.nixosSystem / nix-darwin / home-manager
```

フレーク全体は「複数ホスト構成のリストを受け取り、各ホストの NixOS/Darwin/home-manager 設定を生成する」パイプラインです。

---

## lib/mkModule.nix

モジュールシステムの中核。各 `modules/**/*.nix` がこの関数を呼び出すことで、プラットフォーム横断の設定を一か所に記述できます。

### シグネチャ

```nix
{
  name,                 # ドット区切りのオプションパス。例: "tool.git.basic"
  inheritModule ? "",   # 親モジュール名。例: "tool.git"
  options ? {},         # modules.<name> 配下に追加する NixOS オプション
  commonModule ? {},    # 全プラットフォーム共通の設定・imports
  homeModule ? {},      # Home Manager 設定 (全 OS)
  linuxHomeModule ? {}, # Home Manager 設定 (Linux のみ)
  nixosModule ? {},     # NixOS システム設定
  darwinHomeModule ? {},# Home Manager 設定 (macOS のみ)
  darwinModule ? {},    # nix-darwin システム設定
}
```

各フィールドはアトリビュートセットまたは `{ cfg, config }: { ... }` 形式の関数を受け取ります。
関数形式のとき、引数の `cfg` は `config.modules.<name>` に解決されます。

### 有効化ロジック

```nix
effectiveEnable = cfg.enable || inheritedCfg.enable
```

`modules.<name>.enable = true` が直接セットされているか、`inheritModule` で指定した親の `enable` が true のとき、このモジュールが有効になります。

**例:**
```
modules.lang.enable = true
  → lang.go       (inheritModule = "lang") が有効化
  → lang.rust     (inheritModule = "lang") が有効化
  → lang.wasm     (inheritModule = "lang") が有効化
  → lang.node     (inheritModule = "lang") が有効化
  ...

modules.lang.rust.enable = true (明示)
  → lang.rust のみ有効化
  → lang.wasm は有効化されない (inheritModule = "lang" であるため)
```

### プラットフォームルーティング

`platform` 特殊引数の値に基づいてどの設定ブロックを適用するか決定します。

| platform | host   | 適用されるブロック                         |
|----------|--------|-------------------------------------------|
| `"home"` | `"nixos"` | `homeModule` + `linuxHomeModule`         |
| `"home"` | `"darwin"` | `homeModule` + `darwinHomeModule`       |
| `"nixos"` | —     | `nixosModule`                             |
| `"darwin"` | —    | `darwinModule`                            |

`platform` は評価コンテキストごとに異なります: Home Manager 評価では `"home"`、NixOS システム評価では `"nixos"`、nix-darwin 評価では `"darwin"` が渡されます。

### commonModule の特殊な使い方

`commonModule` は全プラットフォームで無条件に適用されます。`imports` を含めることで、子モジュールを常にモジュールシステムに登録できます。

```nix
# lang/rust/default.nix
mkModule {
  name = "lang.rust";
  inheritModule = "lang";
  commonModule = {
    imports = [ ./wasm.nix ];  # wasm モジュールを常に登録
  };
  homeModule = { ... };
}
```

---

## lib/resolveModules.nix

```nix
specialArgs: modules: [module, ...]
```

モジュールのリストを再帰的に展開し、NixOS モジュール定義のフラットなリストを返します。

### 展開ルール

1. **パス / 文字列** → `import` して再帰
2. **関数** で引数に `mkModule` または `mkEnableOption` を持つ → `specialArgs` を適用して再帰
3. **関数** でそれ以外 → 呼び出し元 (NixOS) に委ねるためそのままリストに格納
4. **アトリビュートセット** で `.imports` を持つ → `imports` を再帰展開、本体はリストに格納

この設計により、`flake.nix` の `modules` アトリビュートセット（`modules.lang.enable = true` のような設定値）と `modules/` ディレクトリ（モジュール定義）の両方を同一インターフェースで処理できます。

### specialArgs に含まれる値

```nix
{
  pkgs          # nixpkgs パッケージセット
  lib           # pkgs.lib
  inputs        # flake inputs
  username      # ホスト設定の username
  homeDirectory # ホスト設定の homeDirectory
  host          # "nixos" | "darwin" | "home"
  system        # "x86_64-linux" | "aarch64-darwin" | ...
  mkModule      # lib/mkModule.nix の関数
  vars          # vars-file input から import した値
  mkEnableOption # pkgs.lib.mkEnableOption
}
```

---

## lib/mkPlatformInner.nix

一つのホスト設定（`flake.nix` のリストの各要素）を受け取り、対応する nixosConfiguration / darwinConfiguration / homeConfiguration を生成します。

### 入力

```nix
{
  name          # 設定名。例: "desktop"
  inputs        # flake inputs
  system        # ターゲットアーキテクチャ
  host          # "nixos" | "darwin" | "home"
  username
  homeDirectory
  modules       # flake.nix で宣言した設定値アトリビュートセット
  homeConfig?   # Home Manager 追加設定
  nixosConfig?  # NixOS 追加設定
  darwinConfig? # nix-darwin 追加設定
}
```

### 処理フロー

1. `pkgs = import inputs.nixpkgs { inherit system; allowBroken = true; allowUnfree = true; }`
2. `vars = import inputs.vars-file.outPath` — 外部変数ファイルをロード
3. `resolveModules` で `[modules, ../modules]` を展開してフラットなリストを生成
4. `platform = "home"` で homeModules を構成 (catppuccin + homeConfig を追加)
5. `platform = "nixos"/"darwin"` でシステム評価用モジュールを構成
6. 対応する `nixosSystem` / `darwinSystem` / `homeManagerConfiguration` を返す

---

## lib/mkPlatform.nix

```nix
configs: { nixosConfigurations = {}; darwinConfigurations = {}; homeConfigurations = {}; }
```

ホスト設定のリストを `mkPlatformInner` にマップし、`foldl'` で結果をマージするだけのシンプルな集約器です。

---

## vars-file 注入パターン

センシティブな設定（git の email など）を flake に直接埋め込まずに注入する仕組みです。

```nix
# flake.nix
vars-file = {
  url = "file+file:///dev/null";  # デフォルトは空
  flake = false;
};
```

```sh
# 適用時に実際の vars.nix を注入
./init.sh nixos desktop
# init.sh 内部で --override-input vars-file "file+file://$VARS_FILE" が渡される
```

`vars.nix` の型は以下のアトリビュートセットを想定:

```nix
{
  gitIncludes = [
    {
      path = "/path/to/gitconfig";  # or
      contents = {
        user.email = "...";
        user.name = "...";
      };
    }
  ];
}
```

`vars` は `specialArgs` 経由で全モジュールに渡されます。現在は `tool.git.basic` で `programs.git.includes = vars.gitIncludes` として使用しています。

---

## platform と host の違い

| 属性 | 値 | 意味 |
|------|-----|------|
| `platform` | `"home"` | Home Manager 評価コンテキスト (ユーザー設定) |
| `platform` | `"nixos"` | NixOS システム評価コンテキスト |
| `platform` | `"darwin"` | nix-darwin 評価コンテキスト |
| `host` | `"nixos"` | ホストの OS が NixOS |
| `host` | `"darwin"` | ホストの OS が macOS |
| `host` | `"home"` | Home Manager standalone |

`platform` はどのモジュールブロックを適用するか決定します。`host` は同一 `platform` 内での OS 分岐に使います（`linuxHomeModule` vs `darwinHomeModule`）。

例: NixOS ホストでは `nixosSystem` 評価 (`platform="nixos"`) と Home Manager 評価 (`platform="home"`, `host="nixos"`) の二回評価が走ります。
