{ pkgs, ... }:

{
  fonts = {
    fonts = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.commit-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];

    fontconfig = {
      hinting.autohint = true;
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        serif = [
          "Noto Serif CJK JP"
          "Noto Color Emoji"
        ];
        sansSerif = [
          "Noto Sans CJK JP"
          "Noto Color Emoji"
        ];
        monospace = [ "Jetbrains Mono" ];
      };
    };
  };
}
