{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    defaultKeymap = "emacs";

    history = {
      save = 10000;
      size = 10000;
    };

    initContent = builtins.readFile ./default.zsh;

    shellAliases = {
      ".." = "cd ../";
      "..." = "cd ../../";

      e = "exit";
      reload = "exec zsh -l";
    };
  };

  imports = [
    ./starship.nix
    ./fzf.nix
    ./eza.nix
    ./zoxide.nix
  ];
}
