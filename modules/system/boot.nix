_:

{
  flake.modules.nixos.base = {
    boot = {
      loader = {
        systemd-boot = {
          enable = true;
          configurationLimit = 10;
          # ブートメニューでカーネル引数を編集できると init=/bin/sh で root が取れる
          editor = false;
        };
        efi.canTouchEfiVariables = true;
      };
      tmp.cleanOnBoot = true;
    };
  };
}
