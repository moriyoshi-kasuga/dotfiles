{
  pkgs,
  mkModule,
  ...
}:

let
  packages = with pkgs; [
    nerd-fonts.jetbrains-mono

    maple-mono.NormalNL-NF

    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];
in
mkModule {
  name = "font";
  darwinModule = {
    fonts = {
      inherit packages;
    };
  };
  nixosModule = {
    fonts = {
      inherit packages;
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
