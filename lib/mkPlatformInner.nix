{
  name,
  inputs,
  system,
  host,
  username,
  homeDirectory,
  modules,
  homeConfig ? { },
  darwinConfig ? { },
  nixosConfig ? { },
}:

let
  pkgs = import inputs.nixpkgs {
    inherit system;
    config = {
      allowBroken = true;
      allowUnfree = true;
    };
  };
  lib = pkgs.lib;
  vars = import inputs.vars-file.outPath;
  mkModule = import ./mkModule.nix;

  specialArgs = {
    inherit
      inputs
      username
      homeDirectory
      host
      system
      mkModule
      vars
      ;
    mkEnableOption = pkgs.lib.mkEnableOption;
  };

  resolveModules = import ./resolveModules.nix;

  resolvedArgs = specialArgs // {
    inherit pkgs;
    lib = pkgs.lib;
  };

  commonModules = resolveModules resolvedArgs [
    {
      modules.base.enable = true;
    }
    modules
    ../modules
  ];

  evalConfig = config: if lib.isFunction config then config pkgs else config;

  homeModules = commonModules ++ [
    inputs.catppuccin.homeModules.catppuccin
    (evalConfig homeConfig)
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
    (evalConfig nixosConfig)
    {
      modules.nixos.enable = true;
    }

    inputs.catppuccin.nixosModules.catppuccin

    inputs.home-manager.nixosModules.home-manager
    hostHomeManager
  ];

  darwinModules = [
    (evalConfig darwinConfig)
    {
      modules.darwin.enable = true;
    }

    inputs.home-manager.darwinModules.home-manager
    hostHomeManager
  ];

in
if "nixos" == host then
  {
    nixosConfigurations.${name} = inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = specialArgs // {
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
  abort "Choice host in nixos, darwin and home"
