_:

{
  flake.modules.homeManager."shell.zsh" =
    { pkgs, ... }:
    {
      programs.zsh = {
        package = pkgs.zsh;
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

  flake.modules.nixos."shell.zsh" = {
    programs.zsh.enable = true;
  };

  flake.modules.darwin."shell.zsh" = {
    programs.zsh.enable = true;
  };
}
