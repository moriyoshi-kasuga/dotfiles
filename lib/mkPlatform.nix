configs:

let
  mkPlatformInner = import ./mkPlatformInner.nix;
  results = map mkPlatformInner configs;
in
builtins.foldl'
  (
    acc: item:
    acc
    // {
      nixosConfigurations = acc.nixosConfigurations // (item.nixosConfigurations or { });
      darwinConfigurations = acc.darwinConfigurations // (item.darwinConfigurations or { });
      homeConfigurations = acc.homeConfigurations // (item.homeConfigurations or { });
    }
  )
  {
    nixosConfigurations = { };
    darwinConfigurations = { };
    homeConfigurations = { };
  }
  results
