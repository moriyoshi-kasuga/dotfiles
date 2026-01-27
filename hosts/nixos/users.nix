{ username, pkgs, ... }:

{
  programs.zsh.enable = true;
  programs.fish.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    description = username;
    group = username;
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      "audio"
      "video"
      "gamemode"
    ];
    shell = pkgs.fish;
    packages = with pkgs; [
      brave
      firefox
      wezterm
      wl-clipboard
      discord
      slack
      aseprite
      ldtk
      prismlauncher
    ];
  };

  users.groups.${username} = {
    name = username;
    members = [ username ];
    gid = 1000;
  };

  # System-wide packages
  environment.systemPackages = with pkgs; [
    vim-full
    wget
    appimage-run
    # LD related
    pkg-config
    zlib
    zstd
    stdenv.cc.cc
    curl
    openssl
    ffmpeg
    udev
    lua5_4
    libssh
  ];

  # Gaming
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  programs.gamemode.enable = true;

  # File Manager / UI Utils
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
  programs.xfconf.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  # Nix-LD
  programs.nix-ld.enable = true;

  catppuccin.cursors.enable = true;

  xdg.mime = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "thunar.desktop" ];
      "text/html" = [ "brave.desktop" ];
      "x-scheme-handler/http" = [ "brave.desktop" ];
      "x-scheme-handler/https" = [ "brave.desktop" ];
    };
  };
}
