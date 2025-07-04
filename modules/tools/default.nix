{ pkgs, ... }:

{
  imports = [
    ./lazygit.nix
    ./tmux.nix
    ./btop.nix
  ];

  home.packages = with pkgs; [
    ripgrep
    fd
    bat
    jq
  ];
}
