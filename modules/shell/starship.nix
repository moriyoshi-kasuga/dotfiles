{ inputs, ... }:

{
  flake.modules.homeManager.base =
    { config, ... }:
    let
      inherit (config.catppuccin) flavor;
      palette =
        (builtins.fromJSON (builtins.readFile "${inputs.catppuccin-palette}/palette.json"))
        .${flavor}.colors;
    in
    {
      programs.starship = {
        enable = true;
        enableZshIntegration = false;
        settings = {
          add_newline = false;

          package.disabled = true;

          java.disabled = true;
          kotlin.disabled = true;
          gradle.disabled = true;
          scala.disabled = true;
          aws.disabled = true;

          palette = "catppuccin_${flavor}";
          palettes."catppuccin_${flavor}" = builtins.mapAttrs (_: color: color.hex) palette;
        };
      };

      # starship は catppuccin/nix に任せず palette を直接渡す: モジュール側は IFD を使うため、
      # 他プラットフォームの構成を評価する nix flake check が失敗する。
      # https://github.com/catppuccin/nix/issues/392
      catppuccin.starship.enable = false;
    };
}
