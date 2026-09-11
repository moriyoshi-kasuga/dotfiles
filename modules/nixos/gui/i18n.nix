_:

{
  flake.modules.nixos."gui.i18n" =
    { pkgs, ... }:
    {
      catppuccin.fcitx5.enable = true;

      # XMODIFIERS is set via the niri "environment" block (see
      # gui/niri/misc.kdl) instead of here: its "@im=fcitx" value makes
      # pam_env warn on every login/sudo ("Expandable variables must be
      # wrapped in {}") since environment.sessionVariables is also exported
      # through /etc/pam/environment.
      environment.sessionVariables = {
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
