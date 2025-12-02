{ pkgs, ... }:

{
  services = {
    # サウンド設定 (PipeWire)
    pulseaudio.enable = false;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # Bluetooth オーディオサポート
      wireplumber.enable = true;
    };

    # Bluetooth マネージャー (GUI)
    blueman.enable = true;
  };
  security.rtkit.enable = true;

  # Bluetooth サポート
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };

  # オーディオ関連パッケージ
  environment.systemPackages = with pkgs; [
    alsa-utils
    pulseaudio # pactl などのユーティリティ
    easyeffects # オーディオエフェクト
    helvum # PipeWire パッチベイ
  ];
}
