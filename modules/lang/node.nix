{ pkgs, ... }:

{
  home.packages = with pkgs; [
    volta
  ];

  programs.zsh.envExtra = ''
    export VOLTA_HOME="$HOME/.volta"
    export PATH="$VOLTA_HOME/bin:$PATH"
  '';
}
