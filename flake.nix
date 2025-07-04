{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }:
    let
      vars = builtins.fromJSON (builtins.getEnv "USER_NIX_VARS");
      pkgs = import nixpkgs { system = vars.system; };
    in
    {
      homeConfigurations.${vars.username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
          ./modules/git
        ];
        extraSpecialArgs = {
          inherit vars;
          rootPath = ./.;
          dotfilesPath = ./dotfiles;
        };
      };
    };
}
