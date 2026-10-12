_:

let
  # style.fonts.monospace で選べるフォント。package は pkgs を受け取る関数にして、
  # option の型 (enum) が pkgs に依存しないようにする。
  # cjk は日本語の字形を含むか: 含まないフォントは端末で Noto CJK に fallback させる。
  monospaceFonts = {
    maple = {
      family = "Maple Mono Normal NL NF";
      package = pkgs: pkgs.maple-mono.NormalNL-NF;
      cjk = false;
    };
    iosevka = {
      family = "IosevkaTerm Nerd Font Mono";
      package = pkgs: pkgs.nerd-fonts.iosevka-term;
      cjk = false;
    };
    plemoljp = {
      family = "PlemolJP Console NF";
      package = pkgs: pkgs.plemoljp-nf;
      cjk = true;
    };
    "monaspace-neon" = {
      family = "MonaspiceNe Nerd Font Mono";
      package = pkgs: pkgs.nerd-fonts.monaspace;
      cjk = false;
    };
  };

  packages =
    pkgs:
    map (font: font.package pkgs) (builtins.attrValues monospaceFonts)
    ++ (with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ]);

  # home 側 (wezterm, noctalia) は osConfig.style.fonts.* から読む
  options =
    { lib, config, ... }:
    {
      options.style.fonts = {
        monospace = lib.mkOption {
          type = lib.types.enum (builtins.attrNames monospaceFonts);
          default = "maple";
          description = "Monospace programming font used system-wide";
        };
        monospaceFont = lib.mkOption {
          type = lib.types.attrs;
          readOnly = true;
          default = removeAttrs monospaceFonts.${config.style.fonts.monospace} [ "package" ];
          description = "Family name (`family`) and CJK coverage (`cjk`) of style.fonts.monospace";
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
          monospace = [ config.style.fonts.monospaceFont.family ];
        };
      };
    };
}
