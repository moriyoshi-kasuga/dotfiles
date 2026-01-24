{
  pkgs,
  homeDirectory,
  config,
  bigMonitor,
  username,
  dotfilesPath,
  ...
}:

let
  weztermConfigRaw = builtins.readFile ../dotfiles/.wezterm.lua;
  weztermConfig =
    builtins.replaceStrings
      [ "@COLORSCHEME@" "\"@BIGMONITOR@\"" ]
      [
        "Catppuccin Mocha"
        (if bigMonitor then "true" else "false")
      ]
      weztermConfigRaw;
in
{
  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "sapphire";
  };

  home = {
    inherit username homeDirectory;
    stateVersion = "25.05";
  };

  home.packages = [
    pkgs.fastfetch
  ];

  home.file = {
    ".wezterm.lua".text = weztermConfig;
    ".config/wezterm".source = ../dotfiles/wezterm;
    ".config/nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/dotfiles/neovim";
      force = true;
    };
    ".config/niri/config.kdl" = {
      source = ../dotfiles/niri/config.kdl;
      # Created default config by niri, so force overwrite
      force = true;
    };
    ".config/opencode/opencode.json".source = ../dotfiles/opencode.json;
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
