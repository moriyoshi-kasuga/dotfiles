{
  config,
  inputs,
  lib,
  ...
}:

{
  perSystem =
    { pkgs, ... }:
    let
      devTools = with pkgs; [
        nixfmt-tree
        statix
        deadnix
        stylua
        shellcheck
      ];

      mkLint =
        name: script:
        pkgs.runCommand "lint-${name}"
          {
            nativeBuildInputs = devTools;
            src = inputs.self;
          }
          ''
            cd "$src"
            ${script}
            touch "$out"
          '';

      # Evaluation is pure, so every configuration can be evaluated on any
      # system. This lets Linux CI catch broken darwin configurations too.
      allConfigs = config.flake.nixosConfigurations // config.flake.darwinConfigurations;
    in
    {
      formatter = pkgs.nixfmt-tree;

      checks = {
        statix = mkLint "statix" "statix check .";
        deadnix = mkLint "deadnix" "deadnix --fail flake.nix modules hosts";
        # treefmt rewrites files before reporting changes, so run it on a writable copy.
        treefmt = mkLint "treefmt" ''
          cp -r "$src" "$TMPDIR/src"
          chmod -R u+w "$TMPDIR/src"
          treefmt --fail-on-change --no-cache --walk filesystem --tree-root "$TMPDIR/src"
        '';
        stylua = mkLint "stylua" "stylua --check --indent-type Spaces --indent-width 2 nvim-config";
        shellcheck = mkLint "shellcheck" "shellcheck init.sh";

        eval-configs = pkgs.runCommand "eval-configs" { } ''
          : ${
            lib.concatMapStringsSep " " (
              cfg: builtins.unsafeDiscardStringContext cfg.config.system.build.toplevel.drvPath
            ) (lib.attrValues allConfigs)
          }
          touch "$out"
        '';
      };

      devShells.default = pkgs.mkShell {
        packages = devTools ++ [ pkgs.nixd ];
      };
    };
}
