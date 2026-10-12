{
  config,
  inputs,
  lib,
  ...
}:

{
  perSystem =
    { pkgs, system, ... }:
    let
      devTools = with pkgs; [
        nixfmt-tree
        statix
        deadnix
        stylua
        shellcheck
        fish
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

      # eval-configs only evaluates, so build the niri config directories here
      # to actually run `niri validate` on them.
      niriConfigs = lib.filterAttrs (
        _: cfg: cfg.config.programs.niri.enable && cfg.pkgs.stdenv.hostPlatform.system == system
      ) config.flake.nixosConfigurations;
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
        stylua = mkLint "stylua" "stylua --check --indent-type Spaces --indent-width 2 nvim-config modules";
        # modules/ の .sh は writeShellApplication が bash で実行する。build 時の shellcheck は
        # eval-configs では走らないので、ここで見る。
        shellcheck = mkLint "shellcheck" ''
          shellcheck --shell=bash init.sh
          find modules -name '*.sh' -exec shellcheck --shell=bash {} +
        '';
        fish = mkLint "fish" ''
          export HOME="$TMPDIR"
          find modules -name '*.fish' -print0 | xargs -0 -n1 fish --no-execute
        '';

        eval-configs = pkgs.runCommand "eval-configs" { } ''
          : ${
            lib.concatMapStringsSep " " (
              cfg: builtins.unsafeDiscardStringContext cfg.config.system.build.toplevel.drvPath
            ) (lib.attrValues allConfigs)
          }
          touch "$out"
        '';
      }
      // lib.mapAttrs' (
        name: cfg: lib.nameValuePair "niri-config-${name}" cfg.config.desktop.niri.configDir
      ) niriConfigs;

      devShells.default = pkgs.mkShell {
        packages = devTools ++ [ pkgs.nixd ];
      };
    };
}
