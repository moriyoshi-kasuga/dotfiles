{
  pkgs,
  vars,
  dotfilesPath,
  config,
  ...
}:

let
  capitalize =
    s:
    pkgs.lib.toUpper (builtins.substring 0 1 s) + builtins.substring 1 (builtins.stringLength s - 1) s;
  catppuccinFlavor = capitalize vars.catppuccinFlavor;
  weztermConfigRaw = builtins.readFile (dotfilesPath + "/.wezterm.lua");
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
  ];

  home.file = {
    ".wezterm.lua".text = weztermConfig;
    ".config/wezterm".source = config.lib.file.mkOutOfStoreSymlink (dotfilesPath + "/wezterm");
    ".config/nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink (dotfilesPath + "/neovim");
      force = true;
    };
    ".config/niri/config.kdl" = {
      source = config.lib.file.mkOutOfStoreSymlink (dotfilesPath + "/niri/config.kdl");
      # Created default config by niri, so force overwrite
      force = true;
    };
    ".config/opencode/opencode.json".source = config.lib.file.mkOutOfStoreSymlink (
      dotfilesPath + "/opencode.json"
    );
  };

  home.sessionVariables = {
    EDITOR = "simplenvim";
    TERMINAL = "wezterm";
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
