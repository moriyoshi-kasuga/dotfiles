{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      mkPlatform = import ./lib/mkPlatform.nix;
    in
    mkPlatform {
      name = "desktop";
      inherit inputs;
      system = "x86_64-linux";
      host = "nixos";
      username = "mori";
      homeDirectory = "/home/mori";
      modules = {
        modules.base.enable = true;
        modules.shell.fish.enable = true;
        modules.shell.fish.default = true;
        modules.shell.zsh.enable = true;
        modules.editor.neovim.enable = true;
        modules.editor.vim.enable = true;
        modules.tool.basic.enable = true;
        modules.tool.tmux.enable = true;
        modules.tool.tff.enable = true;
        modules.tool.git.enable = true;
        modules.tool.git.lazygit.enable = true;
        modules.tool.git.delta.enable = true;
        modules.term.wezterm.enable = true;

        modules.nixos.enable = true;
      };
    }
    // mkPlatform {
      name = "laptop";
      inherit inputs;
      system = "aarch64-darwin";
      host = "darwin";
      username = "mori";
      homeDirectory = "/Users/mori";
      modules = {
        modules.base.enable = true;
        modules.shell.fish.enable = true;
        modules.shell.fish.default = true;
        modules.shell.zsh.enable = true;
        modules.editor.neovim.enable = true;
        modules.editor.vim.enable = true;
        modules.tool.basic.enable = true;
        modules.tool.tmux.enable = true;
        modules.tool.tff.enable = true;
        modules.tool.git.enable = true;
        modules.tool.git.lazygit.enable = true;
        modules.tool.git.delta.enable = true;
        modules.term.wezterm.enable = true;
      };
    };
}
