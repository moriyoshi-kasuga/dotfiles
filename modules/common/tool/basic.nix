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
      package = pkgs.man;
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
    ];

    programs = {
      yazi.enable = true;
      fd.enable = true;
      bat.enable = true;
      jq.enable = true;
      lazydocker.enable = true;
    };

    home.shellAliases = {
      fdh = "fd -H -E \".git\"";
    };
  };
}
