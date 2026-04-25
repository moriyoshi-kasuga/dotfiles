{
  mkModule,
  pkgs,
  ...
}:

mkModule {
  name = "nixos.gui.qt";
  inheritModule = "nixos.gui";
  linuxHomeModule = {
    catppuccin.kvantum.enable = true;

    gtk = {
      enable = true;
      theme = {
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
      };
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "adw-gtk3-dark";
        icon-theme = "Papirus-Dark";
      };
    };

    home.file.".config/qt5ct/qt5ct.conf".text = ''
      [Appearance]
      style=kvantum
      icon_theme=Papirus-Dark

      [Interface]
      buttonbox_layout=0
      menus_have_icons=true
      toolbutton_style=4
    '';
    home.file.".config/qt6ct/qt6ct.conf".text = ''
      [Appearance]
      style=kvantum
      icon_theme=Papirus-Dark

      [Interface]
      buttonbox_layout=0
      menus_have_icons=true
      toolbutton_style=4
    '';
  };
  nixosModule = {
    qt = {
      enable = true;
      style = "kvantum";
      platformTheme = "qt5ct";
    };

    environment.sessionVariables = {
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    };
  };
}
