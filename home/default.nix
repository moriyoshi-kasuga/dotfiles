{
  pkgs,
  homeDirectory,
  config,
  bigMonitor,
  username,
  ...
}:

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

  home.sessionVariables = {
    EDITOR = "simplenvim";
    TERMINAL = "wezterm";
  };

  programs.home-manager.enable = true;

  imports = [
    ./shells/zsh
    ./tools
    ./lang
    ./editors
    ./terminals/wezterm
  ];
}