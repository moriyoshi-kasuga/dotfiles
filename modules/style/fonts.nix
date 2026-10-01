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

  # style.fonts.monospace で選べるフォントと、その family 名
  monospaceFamilies = {
    maple = "Maple Mono Normal NL NF";
    iosevka = "IosevkaTerm Nerd Font Mono";
    plemoljp = "PlemolJP Console NF";
    "monaspace-neon" = "MonaspiceNe Nerd Font Mono";
  };

  # home 側 (wezterm, niri など) は osConfig.style.fonts.* から読む
  options =
    { lib, config, ... }:
    {
      options.style.fonts = {
        monospace = lib.mkOption {
          type = lib.types.enum (builtins.attrNames monospaceFamilies);
          default = "maple";
          description = "Monospace programming font used system-wide";
        };
        monospaceFamily = lib.mkOption {
          type = lib.types.str;
          readOnly = true;
          default = monospaceFamilies.${config.style.fonts.monospace};
          description = "Font family name of style.fonts.monospace";
        };
      };
    };
in
{
  flake.modules.darwin.pc =
    { pkgs, ... }:
    {
      imports = [ options ];
      fonts.packages = packages pkgs;
    };

  flake.modules.nixos.pc =
    { pkgs, config, ... }:
    {
      imports = [ options ];
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
          monospace = [ config.style.fonts.monospaceFamily ];
        };
      };
    };
}
