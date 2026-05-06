# Module Design

このドキュメントはモジュールの設計方針・命名規則・追加方法を説明します。
読者対象は開発者および AI エージェントです。

---

## 命名規則

モジュール名はドット区切りのパスで表現し、NixOS オプションのパスに直接マッピングされます。

```
name = "tool.git.basic"
  → options.modules.tool.git.basic.enable
  → config.modules.tool.git.basic

inheritModule = "tool.git"
  → config.modules.tool.git を参照して有効化を継承
```

### 命名の階層構造

```
<category>.<name>.<variant>

例:
  lang.rust          ← 言語カテゴリ > rust
  lang.rust.wasm     ← rust のサブバリアント
  tool.git.basic     ← ツール > git > 基本設定
  nixos.gui.audio    ← OS固有 > GUI > audio
```

ディレクトリ名とモジュール名の対応:

| ディレクトリ | モジュール名プレフィックス |
|---|---|
| `modules/common/lang/` | `lang.*` |
| `modules/common/tool/` | `tool.*` |
| `modules/common/shell/` | `shell.*` |
| `modules/common/editor/` | `editor.*` |
| `modules/common/terminal/` | `terminal.*` |
| `modules/nixos/` | `nixos.*` |
| `modules/nixos/gui/` | `nixos.gui.*` |
| `modules/darwin/` | `darwin.*` |

---

## inheritModule パターン

`inheritModule` は「親の `enable` を継承する」ための仕組みです。

```nix
# lang/go.nix
mkModule {
  name = "lang.go";
  inheritModule = "lang";  # modules.lang.enable = true で自動有効化
  ...
}
```

### 設計判断の基準

**`inheritModule` に親を指定する場合**: 親が有効なら常に一緒に有効化してよいとき。

```nix
# tool.git.basic は tool.git が有効なら必ず必要
name = "tool.git.basic";
inheritModule = "tool.git";
```

**`inheritModule` に祖父を指定する場合**: 親とは独立して制御したいが、上位の一括有効化には含めたいとき。

```nix
# lang.wasm は lang.enable = true のとき自動有効化するが、
# lang.rust.enable = true だけでは有効化しない (サーバーで rust は使うが wasm は不要)
name = "lang.wasm";
inheritModule = "lang";
```

> **注意**: 親の `enable` が `true` の場合、子モジュールを個別に `false` にしても無効化できません (`effectiveEnable = cfg.enable || inheritedCfg.enable`)。個別に制御する必要がある場合は親の `enable` を使わず、子モジュールを個別に列挙してください（`flake.nix` の `job` ホストの `modules.lang` がその例）。

**`inheritModule` を省略する場合**: 常に明示的な `enable = true` が必要なとき。

```nix
# tool.claude-code は tool.enable = true でも自動有効化しない
# → flake.nix で tool.claude-code.enable = true を明示する
name = "tool.claude-code.basic";
inheritModule = "tool.claude-code";
# tool/claude-code/default.nix で options.modules.tool.claude-code.enable を別途定義
```

---

## ディレクトリ構造パターン

### シンプルなモジュール (単一ファイル)

```
lang/go.nix
```

```nix
mkModule {
  name = "lang.go";
  inheritModule = "lang";
  homeModule = { home.packages = [...]; };
}
```

### 複数バリアントを持つモジュール (ディレクトリ)

```
tool/git/
  default.nix   ← オプション定義 + imports
  basic.nix     ← 基本設定
  delta.nix     ← オプション機能
  lazygit.nix   ← オプション機能
```

`default.nix` は `mkEnableOption` のみを定義し、子モジュールを import します:

```nix
# tool/git/default.nix
{ mkEnableOption, ... }:
{
  options.modules.tool.git.enable = mkEnableOption "enable git settings";
  imports = [ ./basic.nix ./delta.nix ./lazygit.nix ];
}
```

子モジュールは親から継承:

```nix
# tool/git/delta.nix
mkModule {
  name = "tool.git.delta";
  inheritModule = "tool.git";  # git が有効なら delta も有効
  homeModule = { ... };
}
```

### 子モジュールの自動 import (commonModule)

子モジュールをオプションとして常に登録しておきたいが、有効化は別で制御する場合:

```nix
# lang/rust/default.nix
mkModule {
  name = "lang.rust";
  inheritModule = "lang";
  commonModule = {
    imports = [ ./wasm.nix ];  # wasm のオプションを常に登録
  };
  homeModule = { ... };
}
```

---

## モジュールカテゴリ一覧

### common (クロスプラットフォーム)

| モジュール | 有効化方法 | 概要 |
|---|---|---|
| `base` | 常に有効 | Home Manager 基盤・Catppuccin テーマ・stateVersion |
| `shell` | `modules.shell.enable` | Fish / Zsh / Starship / direnv / fzf / zoxide |
| `shell.fish` | `shell.enable` or 明示 | Fish シェル設定・デフォルトシェル設定 |
| `shell.zsh` | `shell.enable` or 明示 | Zsh シェル設定 |
| `shell.basic` | `shell.enable` or 明示 | starship・direnv・eza・zoxide の共通設定 |
| `editor` | `modules.editor.enable` | Neovim / Vim |
| `editor.neovim` | `editor.enable` or 明示 | LSP・TreeSitter・Java/Lombok |
| `terminal.wezterm` | 明示 | WezTerm。`bigMonitor` オプションあり |
| `lang` | `modules.lang.enable` | 全言語を一括有効化 |
| `lang.rust` | `lang.enable` or 明示 | cargo 開発ツール群 |
| `lang.wasm` | `lang.enable` or 明示 | wasm-pack・wasm-bindgen |
| `lang.{go,c,python,...}` | `lang.enable` or 明示 | 各言語ツールチェーン |
| `tool` | `modules.tool.enable` | 全ツールを一括有効化 |
| `tool.basic` | `tool.enable` or 明示 | ripgrep・bat・fd・jq・mise・yazi 等 |
| `tool.git` | 明示 | Git 設定・gh CLI・delta・lazygit |
| `tool.docker` | `tool.enable` or 明示 | Docker エイリアス・lazydocker |
| `tool.tmux` | `tool.enable` or 明示 | tmux + Catppuccin テーマ |
| `tool.claude-code` | 明示 | Claude Code CLI・スキル設定・権限設定 |
| `library` | `modules.library.enable` | 共有ライブラリ・PKG_CONFIG_PATH・LD_LIBRARY_PATH |
| `font` | `modules.font.enable` | JetBrains Mono NF・Maple Mono・Noto CJK |
| `wallpaper` | `modules.wallpaper.enable` | 壁紙ローテーション。`isCatppuccin` オプションあり |

### nixos (NixOS専用)

| モジュール | 有効化方法 | 概要 |
|---|---|---|
| `nixos` | `modules.nixos.enable` | NixOS 全設定を一括有効化 |
| `nixos.basic` | `nixos.enable` or 明示 | ユーザー・sudo・openssh・bootloader・swap |
| `nixos.network` | `nixos.enable` or 明示 | NetworkManager・ホスト名 (options.hostName 必須) |
| `nixos.i18n` | `nixos.enable` or 明示 | タイムゾーン・ロケール |
| `nixos.tailscale` | `nixos.enable` or 明示 | Tailscale VPN |
| `nixos.gui` | `modules.nixos.gui.enable` | GUI 環境を一括有効化 |
| `nixos.gui.basic` | `nixos.gui.enable` or 明示 | libinput・polkit・upower・電源管理・logind |
| `nixos.gui.niri` | `nixos.gui.enable` or 明示 | Niri compositor・Noctalia shell |
| `nixos.gui.audio` | `nixos.gui.enable` or 明示 | PipeWire・ALSA |
| `nixos.gui.bluetooth` | `nixos.gui.enable` or 明示 | Bluetooth |
| `nixos.gui.sddm` | `nixos.gui.enable` or 明示 | SDDM ディスプレイマネージャー |
| `nixos.gui.{nvidia,qt,brave,game,...}` | `nixos.gui.enable` or 明示 | 各種 GUI コンポーネント |
| `nixos.gui.i18n` | `nixos.gui.enable` or 明示 | fcitx5 + mozc 日本語入力 |

### darwin (macOS専用)

| モジュール | 有効化方法 | 概要 |
|---|---|---|
| `darwin` | `modules.darwin.enable` | macOS 設定を一括有効化 |
| `darwin.homebrew` | `darwin.enable` or 明示 | Homebrew casks・iOS 開発ツール |
| `darwin.aerospace` | `darwin.enable` or 明示 | Aerospace タイリングウィンドウマネージャー |
| `darwin.dock` | `darwin.enable` or 明示 | Dock 設定 |
| `darwin.finder` | `darwin.enable` or 明示 | Finder 設定 |
| `darwin.tailscale` | `darwin.enable` or 明示 | Tailscale VPN |

---

## 新規モジュールの追加手順

### 1. ファイルを作成する

```nix
# modules/common/tool/example.nix
{
  pkgs,
  mkModule,
  ...
}:

mkModule {
  name = "tool.example";
  inheritModule = "tool";   # tool.enable = true で自動有効化したい場合
  homeModule = {
    home.packages = with pkgs; [ example-pkg ];
  };
}
```

### 2. 親の default.nix に import を追加する

```nix
# modules/common/tool/default.nix
imports = [
  ...
  ./example.nix   # 追加
];
```

`tool.enable` で自動有効化したくない場合は import は不要で、`flake.nix` で `modules.tool.example.enable = true` を指定します（ただし、モジュール定義自体はどこかに import されている必要があります）。

### 3. flake.nix でホストに適用する (任意)

```nix
modules = {
  modules.tool.example.enable = true;
  # または modules.tool.enable = true で自動有効化
};
```

---

## よくあるパターン

### カスタムオプションの定義

```nix
mkModule {
  name = "terminal.wezterm";
  options = {
    bigMonitor = lib.mkEnableOption "Create a padding for big monitor";
  };
  homeModule = { cfg, ... }: {
    # cfg.bigMonitor で参照
    home.file.".config/wezterm/wezterm.lua".text =
      ''local BIG_MONITOR = ${if cfg.bigMonitor then "true" else "false"}''
      + builtins.readFile ./wezterm.lua;
  };
}
```

### vars.nix の値を使う

```nix
mkModule {
  name = "tool.git.basic";
  inheritModule = "tool.git";
  homeModule = { ... }:
  # vars は specialArgs 経由で自動注入される
  { vars, ... }:  # ← 関数形式で受け取ることも可能だが、
                  #   通常はモジュール引数として受け取る
  ...
}

# 実際の使い方: モジュール関数の引数として受け取る
{ mkModule, vars, ... }:
mkModule {
  homeModule = {
    programs.git.includes = vars.gitIncludes;
  };
}
```

### シンボリックリンクでライブ編集

```nix
homeModule = { config, ... }: {
  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/nvim-config";
};
```

`mkOutOfStoreSymlink` を使うと、Nix ストアにコピーせず元ディレクトリへのシンボリックリンクを張るため、`nvim-config/` の変更が即座に反映されます。ただし、`nix build` によるリプロダシビリティは失われます。
