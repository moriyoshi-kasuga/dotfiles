{ pkgs, vars, ... }:

{
  catppuccin = {
    enable = true;
    flavor = vars.catppuccinFlavor;
    accent = "sapphire";
  };

  home.username = vars.username;
  home.homeDirectory = vars.homeDirectory;

  home.stateVersion = "25.05";

  home.packages = [
    pkgs.fastfetch
    pkgs.nixfmt-rfc-style
  ];

  home.file = {
    ".wezterm.lua".source = ./dotfiles/.wezterm.lua;
    ".config/wezterm".source = ./dotfiles/wezterm;
  };

  home.sessionVariables = {
    EDITOR = "vim";
    CATPPUCCIN_FLAVOR = vars.catppuccinFlavor;
  };

  programs.home-manager.enable = true;
}
