{
  pkgs,
  rustypasteServer,
  ...
}:
let
  fzfDefaultOptions = [
    "--reverse"
    "--style minimal"
    "--tmux 55%,65%"
  ];
  fzfOpts = pkgs.lib.concatStringsSep " " fzfDefaultOptions;
in
{
  home.packages = with pkgs; [
    # use latest version
    bash

    eza
  ];

  programs = {
    starship = {
      enable = true;
      settings = {
        add_newline = false;

        package.disabled = true;

        java.disabled = true;
        kotlin.disabled = true;
        gradle.disabled = true;
        scala.disabled = true;
        aws.disabled = true;
      };
    };
    direnv.enable = true;
    zoxide.enable = true;
    fzf = {
      enable = true;
      defaultOptions = fzfDefaultOptions;
    };
  };

  programs.zsh.initContent = ''
    _run-cdi() {
      zi
      zle reset-prompt 
    }

    zle -N _run-cdi
    bindkey "^G" _run-cdi

    zstyle ':fzf-tab:*' popup-min-size 75 12
    zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'

    # Defer fzf-tab loading
    zsh-defer source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
  '';

  home.sessionVariables = {
    _ZO_EXCLUDE_DIRS = "$HOME:/tmp/*:/var/*:/nix/*:/mnt/*";
    _ZO_FZF_OPTS = fzfOpts;
    FZF_DEFAULT_COMMAND = "fd --hidden --type l --type f --type d --exclude .git --exclude .cache";
  };

  home.shellAliases = {
    ".." = "cd ../";
    "..." = "cd ../../";
    e = "exit";
    todo = "simplenvim ~/todo.md";
    mypaste = "rpaste --server ${rustypasteServer}";

    l = "eza";
    ll = "eza --long --git";
    la = "eza --all";
    lsa = "eza --all --long";
    lt = "eza --tree --git-ignore";
  };

  imports = [
    ./zsh
    ./fish
  ];
}
