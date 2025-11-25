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
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };
  };

  outputs =
    {
      nixpkgs,
      catppuccin,
      home-manager,
      nixos-hardware,
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
          ./hosts/darwin

          home-manager.darwinModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = specialArgs;
              users.${vars.username}.imports = homeModules;
            };
          }
        ];
      };
      nixosConfigurations.${vars.username} = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        system = "${vars.system}";

        modules = [
          catppuccin.nixosModules.catppuccin
          ./hosts/nixos

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = specialArgs;
              users.${vars.username}.imports = homeModules;
            };
          }

          {
            hardware.nvidia.prime = {
              intelBusId = "PCI:0:2:0";
              nvidiaBusId = "PCI:1:0:0";
            };
          }
        ]
        ++ (with nixos-hardware.nixosModules; [
          common-cpu-intel
          common-gpu-nvidia
          common-pc-ssd
          common-pc-laptop
        ]);
      };
    };
}
