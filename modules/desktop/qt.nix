_:

let
  home =
    { pkgs, config, ... }:
    let
      # icon theme は catppuccin の gtk icon module が gtk.iconTheme に入れたもの (Papirus) を使う
      qtctSettings = {
        Appearance = {
          style = "kvantum";
          icon_theme = config.gtk.iconTheme.name;
        };
        Interface = {
          buttonbox_layout = 0;
          menus_have_icons = true;
          toolbutton_style = 4;
        };
      };
    in
    {
      # catppuccin の Kvantum theme は home-manager の qt.enable を条件に生成される
      qt = {
        enable = true;
        platformTheme.name = "qtct";
        style.name = "kvantum";
        qt5ctSettings = qtctSettings;
        qt6ctSettings = qtctSettings;
      };

      # dconf の gtk-theme / icon-theme / color-scheme は home-manager の gtk module が書く
      gtk = {
        enable = true;
        colorScheme = "dark";
        theme = {
          name = "adw-gtk3-dark";
          package = pkgs.adw-gtk3;
        };
      };
    };
in
{
  flake.modules.nixos.pc = {
    people.home.imports = [ home ];

    environment.sessionVariables = {
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    };
  };
}
