{
  mkModule,
  ...
}:

mkModule {
  name = "zsh";
  module = {
    module.shell.enable = true;

    programs.zsh = {
      enable = true;
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

        bindkey "^H" backward-delete-char

        # Defer expensive zstyle configurations
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
        zstyle ':completion:*' menu no
        zstyle ':completion:*' sort false

        # Defer edit-command-line setup
        autoload -Uz edit-command-line
        zle -N edit-command-line
        bindkey "^O" edit-command-line

        _run-cdi() {
          zi
          zle reset-prompt 
        }

        zle -N _run-cdi
        bindkey "^G" _run-cdi
      '';
    };
  };
}
