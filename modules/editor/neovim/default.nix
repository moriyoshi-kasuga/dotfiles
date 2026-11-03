_:

{
  flake.modules.homeManager.base =
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
      inherit (config.catppuccin) flavor;
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
          "--set"
          "CATPPUCCIN_FLAVOR"
          flavor
        ];

        # 言語ごとの language server などは modules/lang/ の各ファイルが足す
        extraPackages = [ pkgs.tree-sitter ];
      };

      home.packages = [
        (pkgs.writeShellScriptBin "simplenvim" ''
          env NVIM_SIMPLE_MODE=1 CATPPUCCIN_FLAVOR=${flavor} ${neovimCmd} "$@"
        '')
        # Only path that writes nvim-config/lazy-lock.json; see config/lazy.lua.
        (pkgs.writeShellScriptBin "nvim-lazy-update" ''
          env NVIM_LAZY_LOCK_UPDATE=1 ${lib.getExe config.programs.neovim.finalPackage} --headless "+Lazy! sync" +qa
        '')
      ];

      programs.fish.interactiveShellInit = ''
        complete -c simplenvim --wraps nvim
      '';

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
