{ ... }:

{
  # ブートローダー設定
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # USB自動サスペンドを無効化
    kernelParams = [
      "usbcore.autosuspend=-1"
    ];
  };
}
