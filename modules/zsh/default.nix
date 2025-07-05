{ dotfilesPath, vars, ... }:

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

    initContent =
      builtins.readFile (dotfilesPath + /.zshrc)
      + ''
        source ${vars.homeDirectory}/.zsh-scripts/mod.zsh
      '';

    shellAliases = {
      ".." = "cd ../";
      "..." = "cd ../../";

      e = "exit";
      reload = "exec zsh";
      todo = "vim ~/todo.md";
    };
  };

  home.file.".zsh-scripts".source = dotfilesPath + /zsh-scripts;

  imports = [
    ./starship.nix
    ./fzf.nix
    ./eza.nix
    ./zoxide.nix
  ];
}
