_:

{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.man = {
        package = pkgs.man-db;
        # programs.fish が mkDefault で有効にする cache の生成は、ビルドが遅くなるので止める
        generateCaches = false;
      };

      home.packages = with pkgs; [
        coreutils
        fastfetch

        ripgrep
        xh
        dust
        duf
        tldr
        zip
        unzipNLS
        bottom
      ];

      programs = {
        yazi.enable = true;
        fd.enable = true;
        bat.enable = true;
        jq.enable = true;

        mise.enable = true;
      };

      home.shellAliases = {
        fdh = "fd -H -E \".git\"";
      };
    };
}
