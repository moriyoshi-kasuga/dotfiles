{
  pkgs,
  mkModule,
  ...
}:

mkModule {
  name = "shell";
  module = {
    home.packages = with pkgs; [
      # use latest version
      bash
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
      eza.enable = true;
      fzf = {
        enable = true;
        tmux = {
          enableShellIntegration = true;
          shellIntegrationOptions = [
            "-p 55%,65%"
          ];
        };
      };
    };

    home.sessionVariables = {
      _ZO_EXCLUDE_DIRS = "$HOME:/tmp/*:/var/*:/nix/*:/mnt/*";
      FZF_DEFAULT_COMMAND = "fd --hidden --type l --type f --type d --exclude .git --exclude .cache";
    };

    home.shellAliases = {
      ".." = "cd ../";
      "..." = "cd ../../";
      e = "exit";
      todo = "simplenvim ~/todo.md";

      l = "eza";
      ll = "eza --long --git";
      la = "eza --all";
      lsa = "eza --all --long";
      lt = "eza --tree --git-ignore";
    };
  };
}
