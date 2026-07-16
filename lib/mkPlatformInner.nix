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
      allowUnfree = true;
    };
    overlays = [ inputs.nix-claude-code.overlays.default ];
  };
  inherit (pkgs) lib;

  # vars-file defaults to an empty file (file+file:///dev/null); fall back to
  # defaults so evaluation (nix flake check, CI, nixd) works without override.
  vars =
    if builtins.readFile inputs.vars-file.outPath == "" then
      { gitIncludes = [ ]; }
    else
      import inputs.vars-file.outPath;
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
    inherit pkgs lib;
  };

  commonModules = resolveModules resolvedArgs [
    modules
    ../modules
  ];

  evalConfig = config: if lib.isFunction config then config pkgs else config;

  homeModules =
    commonModules
    ++ [ inputs.catppuccin.homeModules.catppuccin ]
    # niri module references programs.noctalia, so the option must exist on
    # every Linux home configuration even when the GUI is disabled.
    ++ lib.optionals ("nixos" == host) [ inputs.noctalia.homeModules.default ]
    ++ [ (evalConfig homeConfig) ];

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

    # Reuse the nixpkgs instance imported above (with overlays and config)
    # instead of letting the module system instantiate a second one.
    { nixpkgs.pkgs = pkgs; }

    inputs.catppuccin.nixosModules.catppuccin

    inputs.home-manager.nixosModules.home-manager
    hostHomeManager
  ];

  darwinModules = [
    (evalConfig darwinConfig)

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
      modules = homeModules;
    };
  }
else
  abort "Choice host in nixos, darwin and home"
