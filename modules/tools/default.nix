{ pkgs, ... }:

{
  imports = [
    ./tmux.nix
    ./btop.nix
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
    tailspin
    xh
    dust
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
  ];

  programs.fd.enable = true;
  programs.bat.enable = true;
  programs.jq.enable = true;
}
