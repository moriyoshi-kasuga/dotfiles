{ pkgs, ... }:

{
  imports = [
    ./lazygit.nix
    ./tmux.nix
    ./btop.nix
    ./docker.nix
  ];

  home.packages = with pkgs; [
    ripgrep
    fd
    bat
    jq
  ];
}
