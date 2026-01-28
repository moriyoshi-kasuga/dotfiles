{
  description = "Home Manager configuration";

  inputs = {
    # FIXME: if resolved use unstable: https://github.com/nixos/nixpkgs/issues/483584
    nixpkgs.url = "github:NixOS/nixpkgs/70801e06d9730c4f1704fbd3bbf5b8e11c03a2a7";
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
    vars-file = {
      url = "file+file:///dev/null";
      flake = false;
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      catppuccin,
      home-manager,
      nix-darwin,
      vars-file,
      ...
    }:
    let
      vars = import vars-file.outPath;
      inherit (vars) username;
      inherit (vars) system;
      pkgs = import nixpkgs {
        inherit system;
        config.allowBroken = true;
      };
      homeDirectory =
        if pkgs.stdenv.isLinux then
          "/home/${username}"
        else if pkgs.stdenv.isDarwin then
          "/Users/${username}"
        else
          abort "it system is not supported";
      homeModules = [
        catppuccin.homeModules.catppuccin
        ./home
      ]
      ++ (if pkgs.stdenv.isLinux then [ ./home/linux ] else [ ])
      ++ (if pkgs.stdenv.isDarwin then [ ./home/darwin ] else [ ]);

      specialArgs = {
        inherit vars;
        inherit inputs;
        inherit username;
        inherit system;
        inherit homeDirectory;
        inherit (vars) gitIncludes rustypasteServer;
        bigMonitor = vars.bigMonitor or false;
      };
    in
    {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = specialArgs;
        modules = homeModules;
      };
      darwinConfigurations.${username} = nix-darwin.lib.darwinSystem {
        inherit pkgs;
        inherit specialArgs;

        modules = [
          ./hosts/darwin

          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              extraSpecialArgs = specialArgs;
              users.${username}.imports = homeModules;
            };
          }
        ];
      };
      nixosConfigurations.${username} = nixpkgs.lib.nixosSystem {
        inherit system;
        inherit specialArgs;

        modules = [
          catppuccin.nixosModules.catppuccin
          ./hosts/nixos

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              extraSpecialArgs = specialArgs;
              users.${username}.imports = homeModules;
            };
          }
        ];
      };
    };
}
