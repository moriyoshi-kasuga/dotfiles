{ pkgs, ... }:

{
  # グラフィックス設定
  hardware.graphics.enable = true;

  # NVIDIA GPU 設定
  hardware.nvidia = {
    open = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    nvidiaSettings = true;
    # modesetting.enable = true;

    # NVIDIA Optimus (Intel + NVIDIA) 設定
    prime = {
      sync.enable = true;
      # offload.enable = true;
      # offload.enableOffloadCmd = true;

      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # X11 ディスプレイサーバー設定
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
    videoDrivers = [
      # "modesetting"
      "nvidia"
    ];
  };

  # Libinput (タッチパッド・マウス) サポート
  services.libinput.enable = true;

  # USB hotplug と HID デバイスのサポート
  services.udev = {
    enable = true;
    extraRules = ''
      # すべてのHID入力デバイスの自動サスペンドを無効化
      ACTION=="add", SUBSYSTEM=="usb", DRIVER=="usbhid", TEST=="power/control", ATTR{power/control}="on"

      # 入力デバイスのACL設定
      KERNEL=="event[0-9]*", SUBSYSTEM=="input", TAG+="uaccess"

      # マウスとキーボードの追加サポート
      SUBSYSTEM=="input", GROUP="input", MODE="0660"
      SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", MODE="0664"
    '';
  };

  # 電源管理設定
  powerManagement.enable = true;
  services.upower.enable = true;

  # logind設定
  services.logind.settings.Login.HandlePowerKey = "ignore";
}
