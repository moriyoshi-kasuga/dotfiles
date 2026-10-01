_:

{
  flake.modules.homeManager.base =
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

  flake.modules.nixos.base = {
    programs.zsh.enable = true;
  };

  flake.modules.darwin.base = {
    programs.zsh.enable = true;
  };
}
