{ pkgs, ... }:

{
  # サウンド設定 (PipeWire)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # Bluetooth オーディオサポート
    wireplumber.enable = true;
  };

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

  # Bluetooth マネージャー (GUI)
  services.blueman.enable = true;

  # オーディオ関連パッケージ
  environment.systemPackages = with pkgs; [
    alsa-utils
    pulseaudio # pactl などのユーティリティ
    easyeffects # オーディオエフェクト
    helvum # PipeWire パッチベイ
  ];
}
