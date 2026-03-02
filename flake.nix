{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
      inputs.noctalia-qs.follows = "noctalia-qs";
    };
    noctalia-qs = {
      url = "github:noctalia-dev/noctalia-qs";
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
        modules.shell.enable = true;
        modules.shell.fish.default = true;
        modules.lang.enable = true;
        modules.editor.enable = true;
        modules.tool.enable = true;
        modules.tool.git.enable = true;
        modules.term.wezterm.enable = true;

        modules.nixos.enable = true;
      };
      nixosConfig = {
        imports = [
          ./hosts/desktop/hardware-configuration.nix
        ];
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
        modules.shell.enable = true;
        modules.shell.fish.default = true;
        modules.lang.enable = true;
        modules.editor.enable = true;
        modules.tool.enable = true;
        modules.tool.git.enable = true;
        modules.term.wezterm.enable = true;

        modules.darwin.enable = true;
      };
    };
}
