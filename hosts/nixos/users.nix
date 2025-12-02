{ vars, pkgs, ... }:

{
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

      # ターミナル
      wezterm
      wl-clipboard

      # コミュニケーション
      discord
      slack

      # クリエイティブツール
      aseprite # ピクセルアートエディタ
      ldtk # レベルデザインツールキット
    ];
  };

  # Zsh シェルの有効化
  programs.zsh.enable = true;

  # システム全体のパッケージ
  environment.systemPackages = with pkgs; [
    vim
    wget
  ];
}
