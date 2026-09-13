_:

let
  packages =
    pkgs: with pkgs; [
      maple-mono.NormalNL-NF
      nerd-fonts.iosevka-term
      plemoljp-nf
      nerd-fonts.monaspace

      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];

  # Fontconfig/wezterm family name for each selectable monospace font.
  monospaceFamilies = {
    maple = "Maple Mono Normal NL NF";
    iosevka = "IosevkaTerm Nerd Font Mono";
    plemoljp = "PlemolJP Console NF";
    monaspace-neon = "MonaspiceNe Nerd Font Mono";
  };
in
{
  flake.modules.darwin.font =
    { pkgs, ... }:
    {
      fonts.packages = packages pkgs;
    };

  flake.modules.nixos.font =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {
      options.modules.font.monospace = lib.mkOption {
        type = lib.types.enum (builtins.attrNames monospaceFamilies);
        default = "maple";
        description = "Monospace programming font used system-wide";
      };

      config.fonts = {
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
          monospace = [ monospaceFamilies.${config.modules.font.monospace} ];
        };
      };
    };
}
