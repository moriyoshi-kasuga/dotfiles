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
      tailspin
      hexyl
      marp-cli
      prek
    ];

    programs = {
      yazi.enable = true;
      fd.enable = true;
      bat.enable = true;
      jq.enable = true;
      lazydocker.enable = true;

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
}
