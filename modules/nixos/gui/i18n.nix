{
  mkModule,
  pkgs,
  ...
}:

mkModule {
  name = "nixos.gui.i18n";
  inheritModule = "nixos.gui";
  nixosModule = {
    catppuccin.fcitx5.enable = true;

    environment.sessionVariables = {
      XMODIFIERS = "@im=fcitx";
      QT_IM_MODULE = "fcitx";
      QT_IM_MODULES = "fcitx";
      SDL_IM_MODULE = "fcitx";
      INPUT_METHOD = "fcitx";
    };

    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          fcitx5-mozc
        ];
        settings = {
          globalOptions = {
            "Hotkey" = {
              TriggerKeys = "";
            };
            "Hotkey/ActivateKeys" = {
              "0" = "Alt+Alt_R";
            };
            "Hotkey/DeactivateKeys" = {
              "0" = "Alt+Alt_L";
            };
          };
          inputMethod = {
            GroupOrder = {
              "0" = "Default";
            };
            "Groups/0" = {
              Name = "Default";
              "Default Layout" = "us";
              DefaultIM = "mozc";
            };
            "Groups/0/Items/0" = {
              Name = "keyboard-us";
              Layout = "";
            };
            "Groups/0/Items/1" = {
              Name = "mozc";
              Layout = "";
            };
          };
        };
      };
    };
  };
}
