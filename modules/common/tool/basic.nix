{
  mkModule,
  pkgs,
  ...
}:

mkModule {
  name = "tool.basic";
  inheritModule = "tool";
  homeModule = {
    programs.man = {
      enable = true;
      generateCaches = true;
      package = pkgs.man-db;
    };

    home.packages = with pkgs; [
      coreutils

      ripgrep
      jid
      tailspin
      xh
      dust
      duf
      tldr
      zip
      unzipNLS
      lnav
      bottom
      just
      hexyl
      marp-cli
      prek

      tokei
      hyperfine
      oha
    ];

    programs = {
      yazi.enable = true;
      fd.enable = true;
      bat.enable = true;
      jq.enable = true;

      mise = {
        enable = true;
        globalConfig = {
          settings = {
            not_found_auto_install = true;
          };
        };
      };
    };

    home.shellAliases = {
      fdh = "fd -H -E \".git\"";
    };
  };
  linuxHomeModule = {
    home.packages = with pkgs; [
      xdg-utils
      cyme
    ];
  };
}
