{
  pkgs,
  vars,
  dotfilesPath,
  ...
}:

let
  capitalize =
    s:
    pkgs.lib.toUpper (builtins.substring 0 1 s) + builtins.substring 1 (builtins.stringLength s - 1) s;
  catppuccinFlavor = capitalize vars.catppuccinFlavor;
  weztermConfigRaw = builtins.readFile (dotfilesPath + /.wezterm.lua);
  weztermConfig =
    builtins.replaceStrings [ "@COLORSCHEME@" ] [ "Catppuccin ${catppuccinFlavor}" ]
      weztermConfigRaw;
in
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
    ".wezterm.lua".text = weztermConfig;
    ".config/wezterm".source = dotfilesPath + /wezterm;
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs.home-manager.enable = true;

  imports = [
    ./zsh
    ./git
    ./tools
    ./lang
    ./editor
  ];
}
