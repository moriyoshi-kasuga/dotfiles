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
      homeModules = [
        catppuccin.homeModules.catppuccin
        ./home
      ]
      ++ (if pkgs.stdenv.isLinux then [ ./home/linux ] else [ ])
      ++ (if pkgs.stdenv.isDarwin then [ ./home/darwin ] else [ ])
      ++ [ ./home/pkg.nix ];

      specialArgs = {
        inherit vars;
        dotfilesPath = ./dotfiles;
      };
    in
    {
      homeConfigurations.${vars.username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = specialArgs;
        modules = homeModules;
      };
      darwinConfigurations.${vars.username} = nix-darwin.lib.darwinSystem {
        inherit specialArgs;

        modules = [
          ./nix-darwin
        ];
      };
      nixosConfigurations.${vars.username} = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        system = "${vars.system}";

        modules = [
          catppuccin.nixosModules.catppuccin
          ./configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = specialArgs;
              users.${vars.username}.imports = homeModules;
            };
          }
        ];
      };
    };
}
