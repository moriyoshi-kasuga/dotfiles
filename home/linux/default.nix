{ pkgs, ... }:

{
  imports = [
    ./niri
  ];

  home.packages = with pkgs; [
    (writeShellScriptBin "pbpaste" ''
      wl-paste --no-newline
    '')
    (writeShellScriptBin "pbcopy" ''
      wl-copy --trim-newline
    '')
    (writeShellScriptBin "open" ''
      xdg-open "$@"
    '')
    (writeShellScriptBin "wigo" ''
      RUSTFLAGS="-Clinker=clang -Clink-args=--ld-path=wild" cargo $@
    '')
    wild-unwrapped
    xdg-utils
    docker
    docker-compose
    clang-tools
    clang
    gcc-unwrapped
  ];

  programs.zathura = {
    enable = true;
    # ref: https://sheepla.github.io/sheepla-note/posts/zathura-introduction/
    extraConfig = ''
      # ズームイン・スームアウトやスクロールの段階
      set zoom-step 20
      set scroll-step 80

      # クリップボードを有効にする
      set selection-clipboard clipboard

      # インクリメンタル検索を有効にする
      set incremental-search true

      # キーバインド
      map u scroll half-up
      map d scroll half-down
      map D toggle_page_mode
      map K zoom in
      map J zoom out

      # ステータスバーに表示されるファイルパスのホームディレクトリを ~ に変更
      set statusbar-home-tilde true

      # ウインドウタイトルをファイルのbasenameにする
      set window-title-basename true

      # UI要素の表示・非表示
      set guioptions cshv

      # UIのフォント
      set font "monospace 12"

      # 1ページ表示で起動（二分割しない）
      set pages-per-row 1
      set first-page-column 1

      # ページ表示の調整
      set adjust-open "best-fit"
      set scroll-page-aware true
      set scroll-full-overlap 0.01
      set recolor-keephue true
      set recolor-reverse-video true
      set render-loading false
      set window-title-page true
    '';
  };
}
