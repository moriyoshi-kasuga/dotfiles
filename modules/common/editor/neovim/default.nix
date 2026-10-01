_:

{
  flake.modules.homeManager."editor.neovim" =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      treesitter = pkgs.vimPlugins.nvim-treesitter;
      treesitterGrammars = treesitter.withAllGrammars;
      grammarsPath = pkgs.symlinkJoin {
        name = "nvim-treesitter-grammars";
        paths = treesitterGrammars.dependencies;
      };
      neovim = pkgs.neovim-unwrapped;
      neovimCmd = pkgs.lib.getExe neovim;
    in
    {
      catppuccin.nvim.enable = false;

      programs.neovim = {
        enable = true;
        package = neovim;

        extraWrapperArgs = [
          "--set"
          "TREESITTER_PATH"
          "${treesitter}/runtime"
          "--set"
          "TREESITTER_GRAMMARS"
          "${grammarsPath}"
        ];

        extraPackages = with pkgs; [
          tree-sitter

          # shell
          bash-language-server
          shellcheck
          shfmt

          # lua
          lua-language-server
          stylua

          # HTML/CSS/JSON
          vscode-langservers-extracted

          # nix
          nixd
          nixfmt

          # elm
          elmPackages.elm-language-server
          elmPackages.elm-format

          # single package for each lang
          just-lsp
          hadolint
          actionlint
          taplo
          tinymist
        ];
      };

      home.packages = [
        (pkgs.writeShellScriptBin "simplenvim" ''
          env NVIM_SIMPLE_MODE=1 ${neovimCmd} "$@"
        '')
      ];

      home.shellAliases = {
        v = "nvim";
        todo = "simplenvim ~/todo.md";
      };

      home.sessionVariables = {
        MANPAGER = "simplenvim +Man!";
        EDITOR = "simplenvim";
      };

      # Prevent programs.neovim from generating init.lua inside the symlinked dir.
      # home-manager sorts files by path length and processes .config/nvim first,
      # so realpath -m on .config/nvim/init.lua resolves through the out-of-store
      # symlink to /home/mori/dotfiles/nvim-config/init.lua — outside $realOut.
      xdg.configFile."nvim/init.lua" = lib.mkForce { enable = false; };

      home.file.".config/nvim".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim-config";
    };
}
