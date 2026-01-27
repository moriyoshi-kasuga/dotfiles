{
  pkgs,
  homeDirectory,
  ...
}:

let
  zshConfigDefault = pkgs.lib.mkOrder 1000 (builtins.readFile ./zshrc);
  zshConfigAfter = pkgs.lib.mkOrder 1500 ''
    if [[ -f $HOME/.local.zshrc ]]; then
      source $HOME/.local.zshrc
    fi

    source ${homeDirectory}/.zsh-scripts/user.sh
    source ${homeDirectory}/.zsh-scripts/pyvenv.sh
  '';
in
{
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

    initContent = pkgs.lib.mkMerge [
      zshConfigDefault
      zshConfigAfter
    ];
  };

  home.file.".zsh-scripts".source = ./scripts;
}
