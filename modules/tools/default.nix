{ pkgs, ... }:

{
  imports = [
    ./tmux.nix
    ./btop.nix
    ./docker.nix
    ./lazydocker.nix
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
  ];

  programs.fd.enable = true;
  programs.bat.enable = true;
  programs.jq.enable = true;
}
