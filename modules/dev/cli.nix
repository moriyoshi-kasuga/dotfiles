_:

let
  linuxHome =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.cyme ];
    };
in
{
  flake.modules.nixos.base.people.home.imports = [ linuxHome ];

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

        tokei
        hyperfine
        kalker
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
