{
  mkModule,
  pkgs,
  ...
}:

mkModule {
  name = "nixos.font";
  inheritModule = "nixos";
  nixosModule = {
    fonts = {
      packages = with pkgs; [
        nerd-fonts.jetbrains-mono

        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
      ];
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
