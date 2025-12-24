{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fzf
  ];

  programs = {
    fzf = {
      enable = true;
    };
  };

  programs.zsh.initContent = ''
    export FZF_DEFAULT_OPTS='--style minimal --tmux 75%,85%'
    export FZF_DEFAULT_COMMAND='fd --hidden --type l --type f --type d --exclude .git --exclude .cache';
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

    zstyle ':fzf-tab:*' popup-min-size 75 12
    zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'

    # Defer fzf-tab loading
    zsh-defer source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
  '';
}
