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
      module = {
        module.fish.enable = true;
      };
    }
    // mkPlatform {
      name = "laptop";
      inherit inputs;
      system = "aarch64-darwin";
      host = "darwin";
      username = "mori";
      homeDirectory = "/Users/mori";
      module = {
        module.fish.enable = true;
      };
    };
}
