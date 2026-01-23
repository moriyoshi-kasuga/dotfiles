{
  pkgs,
  homeDirectory,
  config,
  bigMonitor,
  username,
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
    ".config/wezterm".source = config.lib.file.mkOutOfStoreSymlink ../dotfiles/wezterm;
    ".config/nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink ../dotfiles/neovim;
      force = true;
    };
    ".config/niri/config.kdl" = {
      source = config.lib.file.mkOutOfStoreSymlink ../dotfiles/niri/config.kdl;
      # Created default config by niri, so force overwrite
      force = true;
    };
    ".config/opencode/opencode.json".source =
      config.lib.file.mkOutOfStoreSymlink ../dotfiles/opencode.json;
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
