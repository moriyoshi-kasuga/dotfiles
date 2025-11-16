{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    catppuccin.url = "github:catppuccin/nix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      catppuccin,
      home-manager,
      nix-darwin,
      ...
    }:
    let
      vars = builtins.fromJSON (builtins.getEnv "USER_NIX_VARS");
      pkgs = import nixpkgs { system = vars.system; };
      dotfilesPath = ./dotfiles;
      linuxModules = if pkgs.stdenv.isLinux then [ ./linux ] else [ ];
      darwinModules = if pkgs.stdenv.isDarwin then [ ./darwin ] else [ ];
    in
    {
      homeConfigurations.${vars.username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          catppuccin.homeModules.catppuccin
          ./home.nix
          ./modules
        ]
        ++ linuxModules
        ++ darwinModules
        ++ [ ./pkg.nix ];

        extraSpecialArgs = {
          inherit vars;
          inherit dotfilesPath;
        };
      };
      darwinConfigurations.${vars.darwinUsername} = nix-darwin.lib.darwinSystem {
        modules = [
          home-manager.darwinModules.home-manager
          ./nix-darwin
        ];
      };
    };
}
