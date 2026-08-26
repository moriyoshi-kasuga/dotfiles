_:

{
  flake.modules.homeManager."tool.basic" =
    { pkgs, lib, ... }:
    {
      programs.man = {
        enable = true;
        generateCaches = true;
        package = pkgs.man-db;
      };

      home.packages =
        (with pkgs; [
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
          graphviz
          typst

          tokei
          hyperfine
          oha
          kalker
          poppler-utils
        ])
        ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux (
          with pkgs;
          [
            xdg-utils
            cyme
          ]
        );

      programs = {
        yazi.enable = true;
        fd.enable = true;
        bat.enable = true;
        jq.enable = true;

        mise = {
          enable = true;
          # HACK: avoid fail compile. temporary override
          # ref: https://github.com/NixOS/nixpkgs/blob/master/pkgs/by-name/mi/mise/package.nix
          package = pkgs.mise.overrideAttrs (old: {
            doCheck = false;
            nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.cmake ];
          });
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
