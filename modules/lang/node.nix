{ pkgs, ... }:

{
  home.packages = with pkgs; [
    volta
    bun
  ];

  programs.zsh.envExtra = ''
    export VOLTA_HOME="$HOME/.volta"
    export PATH="$VOLTA_HOME/bin:$PATH"

    export PATH="$HOME/.bun/bin:$PATH"
  '';
}
