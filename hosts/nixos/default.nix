{ ... }:

{
  imports = [
    # ハードウェアスキャン結果
    ./hardware-configuration.nix

    # NixOS システム設定モジュール
    ./boot.nix # ブートローダー設定
    ./hardware.nix # ハードウェア・GPU・USB設定
    ./audio.nix # オーディオ・Bluetooth設定
    ./users.nix # ユーザーアカウント・パッケージ設定
    ./services.nix # システムサービス設定
    ./gaming.nix # ゲーミング設定

    # その他のモジュール
    ./nixos.nix # Nix デーモン設定
    ./network.nix # ネットワーク設定
    ./region.nix # 地域・言語設定
    ./fonts.nix # フォント設定
    ./virtualisation.nix # 仮想化設定
    ./niri.nix # Niri ウィンドウマネージャー設定
    ./sddm.nix # SDDM ログイン画面設定
    ./ld.nix
  ];

  home-manager.backupFileExtension = "nixbackup";

  # NixOS バージョン (初期インストール時のバージョンを維持)
  system.stateVersion = "25.05";
}
