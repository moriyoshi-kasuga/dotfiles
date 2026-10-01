{ inputs, ... }:

let
  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "macchiato";
    accent = "sapphire";
    # palette を derivation ではなく flake input から読ませて IFD を避ける (tty など)
    # https://github.com/catppuccin/nix/issues/392
    sources.palette = inputs.catppuccin-palette.outPath;
  };
in
{
  flake.modules.homeManager.base = {
    imports = [ inputs.catppuccin.homeModules.catppuccin ];
    inherit catppuccin;
  };

  flake.modules.nixos.base = {
    imports = [ inputs.catppuccin.nixosModules.catppuccin ];
    inherit catppuccin;
  };
}
