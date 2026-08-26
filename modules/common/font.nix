_:

let
  packages =
    pkgs: with pkgs; [
      nerd-fonts.jetbrains-mono

      maple-mono.NormalNL-NF

      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];
in
{
  flake.modules.darwin.font =
    { pkgs, ... }:
    {
      fonts.packages = packages pkgs;
    };

  flake.modules.nixos.font =
    { pkgs, ... }:
    {
      fonts = {
        packages = packages pkgs;
        fontconfig.defaultFonts = {
          emoji = [ "Noto Color Emoji" ];
          serif = [
            "Noto Serif CJK JP"
            "Noto Color Emoji"
          ];
          sansSerif = [
            "Noto Sans CJK JP"
            "Noto Color Emoji"
          ];
          monospace = [ "JetBrains Mono" ];
        };
      };
    };
}
