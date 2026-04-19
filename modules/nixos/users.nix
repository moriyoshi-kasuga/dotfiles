{ username, pkgs, ... }:

{
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
    packages = with pkgs; [
      brave
      firefox
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

  # Nix-LD
  programs.nix-ld = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    vim-full
    wget
    appimage-run
  ];

  # Gaming
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
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
  services.udisks2.enable = true;
  programs.xfconf.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  # Dictionary
  services.dictd = {
    enable = true;
    DBs = with pkgs.dictdDBs; [
      wordnet
      jpn2eng
      eng2jpn
    ];
  };

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
