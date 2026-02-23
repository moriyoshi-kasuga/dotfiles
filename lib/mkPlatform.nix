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

  homeModules = commonModules ++ [
    inputs.catppuccin.homeModules.catppuccin
    modules
  ];

  hostHomeManager = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = specialArgs // {
        platform = "home";
      };
      users.${username}.imports = homeModules;
    };
  };

  nixosModules = [
    inputs.catppuccin.nixosModules.catppuccin

    inputs.home-manager.nixosModules.home-manager
    hostHomeManager
    modules
  ];

  darwinModules = [
    inputs.home-manager.darwinModules.home-manager
    hostHomeManager
    modules
  ];

  object =
    if "nixos" == host then
      {
        nixosConfigurations.${name} = inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = specialArgs // {
            inherit pkgs;
            platform = "nixos";
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
            platform = "darwin";
          };
          modules = commonModules ++ darwinModules;
        };
      }
    else if "home" == host then
      {
        homeConfigurations.${name} = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = specialArgs // {
            platform = "home";
          };
          modules = commonModules ++ homeModules;
        };
      }
    else
      abort "Choice host in nixos, darwin and home";
in
object
