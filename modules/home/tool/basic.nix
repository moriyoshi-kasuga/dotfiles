{
  mkModule,
  pkgs,
  ...
}:

mkModule {
  name = "tool.basic";
  module = {
    home.packages = with pkgs; [
      ripgrep
      jid
      tailspin
      xh
      dust
      duf
      tldr
      zip
      unzip
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
