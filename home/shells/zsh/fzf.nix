{ pkgs, ... }:

let
  defaultOptions = [
    "--reverse"
    "--style minimal"
    "--tmux 55%,65%"
  ];
  opts = pkgs.lib.concatStringsSep " " defaultOptions;
in
{
  programs = {
    fzf = {
      enable = true;
      enableZshIntegration = true;
      inherit defaultOptions;
    };
  };

  home.sessionVariables = {
    _ZO_FZF_OPTS = opts;
    FZF_DEFAULT_COMMAND = "fd --hidden --type l --type f --type d --exclude .git --exclude .cache";
  };

  programs.zsh.initContent = ''
    zstyle ':fzf-tab:*' popup-min-size 75 12
    zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'

    # Defer fzf-tab loading
    zsh-defer source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
  '';
}
