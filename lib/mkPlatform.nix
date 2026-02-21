{ ... }:

{
  inputs,
  system,
  host,
  username,
  homeDirectory,
  module,
}:

let
  pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowBroken = true;
  };
  homeModules = [
    inputs.catppuccin.homeModules.catppuccin
    (import ../modules/home {
      inherit username homeDirectory;
    })
    module
  ];
  specialArgs = {
    inherit inputs username system;
  };
  object =
    if "nixos" == host then
      {
        nixosConfigurations.${username} = inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          inherit specialArgs;

          modules = [
            inputs.catppuccin.nixosModules.catppuccin
            ../modules/nixos
            module

            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = specialArgs;
                users.${username}.imports = homeModules;
              };
            }
          ];
        };
      }
    else if "darwin" == host then
      {
        darwinConfigurations.${username} = inputs.nix-darwin.lib.darwinSystem {
          inherit pkgs;
          inherit specialArgs;

          modules = [
            ../modules/darwin
            module

            inputs.home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = specialArgs;
                users.${username}.imports = homeModules;
              };
            }
          ];
        };
      }
    else if "home" == host then
      {
        homeConfigurations.${username} = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = specialArgs;
          modules = homeModules;
        };
      }
    else
      abort "Choice host in nixos, darwin and home";
in
object
