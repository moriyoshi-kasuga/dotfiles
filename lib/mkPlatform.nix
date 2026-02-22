{ ... }:

{
  name,
  inputs,
  system,
  host,
  username,
  homeDirectory,
  modules,
}:

let
  pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowBroken = true;
  };
  mkModule = import ./mkModule.nix;

  specialArgs = {
    inherit
      inputs
      username
      homeDirectory
      host
      system
      mkModule
      ;
  };

  commonModules = [
    ../modules
  ];

  homeModules = [
    inputs.catppuccin.homeModules.catppuccin
    ../modules/home
    {
      modules.home.base.enable = true;
    }
    modules
  ];

  hostHomeManager = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = specialArgs;
      users.${username}.imports = homeModules;
    };
  };

  nixosModules = [
    inputs.catppuccin.nixosModules.catppuccin
    ../modules/nixos

    inputs.home-manager.nixosModules.home-manager
    hostHomeManager
    {
      modules.nixos.base.enable = true;
    }
    modules
  ];

  darwinModules = [
    ../modules/darwin

    inputs.home-manager.darwinModules.home-manager
    hostHomeManager
    {
      modules.darwin.base.enable = true;
    }
    modules
  ];

  object =
    if "nixos" == host then
      {
        nixosConfigurations.${name} = inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = specialArgs // {
            inherit pkgs;
          };
          modules = commonModules ++ nixosModules;
        };
      }
    else if "darwin" == host then
      {
        darwinConfigurations.${name} = inputs.nix-darwin.lib.darwinSystem {
          inherit pkgs;
          specialArgs = specialArgs // {
            inherit pkgs;
          };
          modules = commonModules ++ darwinModules;
        };
      }
    else if "home" == host then
      {
        homeConfigurations.${name} = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = specialArgs;
          modules = commonModules ++ homeModules;
        };
      }
    else
      abort "Choice host in nixos, darwin and home";
in
object
