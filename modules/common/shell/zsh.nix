{
  lib,
  pkgs,
  mkModule,
  username,
  ...
}:

with lib;
let
  package = pkgs.zsh;
in
mkModule {
  name = "shell.zsh";
  inheritModule = "shell";
  options = {
    default = mkEnableOption "Use zsh to default shell";
  };
  commonModule = {
    modules.shell.basic.enable = true;
    programs.zsh.enable = true;
  };
  homeModule = {
    programs.zsh = {
      inherit package;
      enableCompletion = false;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      defaultKeymap = "emacs";

      history = {
        save = 10000;
        size = 10000;
        path = "$HOME/.zsh_history";
        ignoreAllDups = true;
      };

      initContent = ''
        # Skip some initialization for non-interactive shells
        [[ $- != *i* ]] && return

        bindkey "^D" backward-delete-char
      '';
    };
  };
  nixosModule =
    { cfg, ... }:
    {
      users.users.${username}.shell = mkIf cfg.default package;
    };
  darwinModule =
    { cfg, ... }:
    {
      environment.shells = [ package ];
      users.users.${username}.shell = mkIf cfg.default package;
    };
}
