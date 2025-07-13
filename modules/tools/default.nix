{ pkgs, ... }:

{
  imports = [
    ./tmux.nix
    ./btop.nix
    ./docker.nix
    ./lazydocker.nix
    ./tff.nix
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
    yazi

    # Download latest version
    bash
  ];

  programs.fd.enable = true;
  programs.bat.enable = true;
  programs.jq.enable = true;
}
