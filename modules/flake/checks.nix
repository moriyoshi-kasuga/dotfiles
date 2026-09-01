{ inputs, ... }:

{
  perSystem =
    { system, ... }:
    let
      pkgs = import inputs.nixpkgs { inherit system; };

      devTools = with pkgs; [
        nixfmt-tree
        statix
        deadnix
        stylua
        shellcheck
      ];
    in
    {
      formatter = pkgs.nixfmt-tree;

      checks =
        {
          lint =
            pkgs.runCommand "lint"
              {
                nativeBuildInputs = devTools;
                src = inputs.self;
              }
              ''
                cd "$src"
                statix check .
                deadnix --fail --exclude '**/hardware-configuration.nix' flake.nix modules profiles hosts
                treefmt --fail-on-change --no-cache --walk filesystem --tree-root .
                stylua --check --indent-type Spaces --indent-width 2 nvim-config
                shellcheck init.sh
                touch $out
              '';
        }
        // (
          let
            allConfigs = inputs.self.nixosConfigurations // inputs.self.darwinConfigurations;
            nativeConfigs = pkgs.lib.filterAttrs (
              _: cfg: cfg.pkgs.stdenv.hostPlatform.system == system
            ) allConfigs;
            drvPaths = pkgs.lib.mapAttrsToList (
              _: cfg: builtins.unsafeDiscardStringContext cfg.config.system.build.toplevel.drvPath
            ) nativeConfigs;
          in
          pkgs.lib.optionalAttrs (nativeConfigs != { }) {
            eval-configs = pkgs.runCommand "eval-configs" { } ''
              : ${builtins.concatStringsSep " " drvPaths}
              touch $out
            '';
          }
        );

      devShells.default = pkgs.mkShell {
        packages = devTools ++ [ pkgs.nixd ];
      };
    };
}
