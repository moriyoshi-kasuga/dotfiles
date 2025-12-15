{ vars, pkgs, ... }:

{
  catppuccin.cursors.enable = true;

  # ユーザーアカウント設定
  users.users.${vars.username} = {
    isNormalUser = true;
    description = "${vars.username}";
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      "audio"
      "video"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      # ブラウザ
      brave
      firefox

      # ターミナル
      wezterm
      wl-clipboard

      # コミュニケーション
      discord
      slack

      # クリエイティブツール
      aseprite # ピクセルアートエディタ
      ldtk # レベルデザインツールキット

      # Minecraft Launcher
      prismlauncher
    ];
  };

  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
  programs.xfconf.enable = true;
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  # Zsh シェルの有効化
  programs.zsh.enable = true;

  # システム全体のパッケージ
  environment.systemPackages = with pkgs; [
    vim-full
    wget
    appimage-run
  ];

  xdg.mime = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "thunar.desktop" ];
      "text/html" = [ "brave.desktop" ];
      "x-scheme-handler/http" = [ "brave.desktop" ];
      "x-scheme-handler/https" = [ "brave.desktop" ];
    };
  };
}
