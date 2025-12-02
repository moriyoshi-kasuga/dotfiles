{ pkgs, ... }:

{
  imports = [
    ./tmux.nix
    ./docker.nix
    ./lazydocker.nix
    ./tff.nix
    ./yazi.nix
  ];

  home.packages = with pkgs; [
    ripgrep
    fd
    bat
    jq
    jid
    tailspin
    xh
    dust
    duf
    git-cliff
    kind
    kubernetes-helm
    tldr
    gh
    google-java-format
    zip
    unzip
    lnav
    glow
    bottom
  ];

  programs.fd.enable = true;
  programs.bat.enable = true;
  programs.jq.enable = true;
}
