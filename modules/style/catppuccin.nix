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
  # catppuccin/nix のテーマを使わずに色を組み立てる module (fzf, starship) は style.palette から読む
  flake.modules.homeManager.base =
    { config, lib, ... }:
    let
      palette = lib.importJSON "${config.catppuccin.sources.palette}/palette.json";
    in
    {
      imports = [ inputs.catppuccin.homeModules.catppuccin ];
      config = { inherit catppuccin; };

      options.style.palette = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        readOnly = true;
        default = lib.mapAttrs (_: color: color.hex) palette.${config.catppuccin.flavor}.colors;
        description = "Hex color (`#rrggbb`) of each Catppuccin color name in the active flavor.";
      };
    };

  flake.modules.nixos.base = {
    imports = [ inputs.catppuccin.nixosModules.catppuccin ];
    inherit catppuccin;
  };
}
