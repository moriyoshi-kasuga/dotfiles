{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nodejs_latest
    bun
  ];

  programs.zsh.envExtra = ''
    export PATH="$HOME/.bun/bin:$PATH"
  '';
}
