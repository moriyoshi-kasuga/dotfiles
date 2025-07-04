{ pkgs, ... }:

{
  imports = [
    ./tmux.nix
    ./btop.nix
    ./docker.nix
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
  ];

  programs.fd.enable = true;
  programs.bat.enable = true;
  programs.jq.enable = true;
}
