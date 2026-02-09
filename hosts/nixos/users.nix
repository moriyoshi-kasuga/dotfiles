{ username, pkgs, ... }:

let
  # LD related
  library = with pkgs; [
    pkg-config
    # List by default
    zlib
    zstd
    stdenv.cc.cc
    curl
    openssl
    attr
    libssh
    bzip2
    libxml2
    acl
    libsodium
    util-linux
    xz
    systemd

    # My own additions
    libxcomposite
    libxtst
    libxrandr
    libxext
    libx11
    libxfixes
    libGL
    libva
    pipewire
    libxcb
    libxdamage
    libxshmfence
    libxxf86vm
    libelf
    ffmpeg
    udev
    lua5_4
  ];
in
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
      imhex
    ];
  };

  users.groups.${username} = {
    name = username;
    members = [ username ];
    gid = 1000;
  };

  # System-wide packages
  environment.systemPackages =
    with pkgs;
    [
      vim-full
      wget
      appimage-run
    ]
    ++ library;

  # Nix-LD
  programs.nix-ld = {
    enable = true;
    libraries = library;
  };

  # ref: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/programs/nix-ld.nix#L42
  environment.sessionVariables = {
    LD_LIBRARY_PATH = "/run/current-system/sw/share/nix-ld/lib";
  };

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
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
  programs.xfconf.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;

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
