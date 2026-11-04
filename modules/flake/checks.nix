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

      # 層 (base / pc) を除いた、ホストが個別に選ぶ module の名前
      aspects =
        class:
        lib.concatStringsSep "\n" (
          lib.subtractLists [ "base" "pc" ] (lib.attrNames config.flake.modules.${class})
        );
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
        # README の一覧のうち網羅しているもの (任意の機能、Hosts、modules/ 直下) を実際の定義と照合する。
        # ディレクトリの中身の説明は網羅しないので見ない。照合する書式は次の 3 つで、それぞれの節の中だけを読む:
        # 「### 層」の「- <class>: `名前` / `名前`」の 1 行、「## Hosts」の表の 1 列目、「### ディレクトリ」の 2 字下げの「  - `名前`」
        readme = mkLint "readme" ''
          status=0
          compare() {
            if ! diff <(sort <<<"$2") <(sort <<<"$3") >"$TMPDIR/diff"; then
              echo "README.md の $1 が実際と違う (<: README にだけある、>: flake にだけある、書式は modules/flake/checks.nix の readme を参照)"
              cat "$TMPDIR/diff"
              status=1
            fi
          }
          listed() { sed -n "/^### 層/,/^### /s/^- $1: //p" README.md | grep -o '`[^`]*`' | tr -d '`'; }
          compare "任意の機能 (homeManager)" "$(listed homeManager)" "${aspects "homeManager"}"
          compare "任意の機能 (nixos)" "$(listed nixos)" "${aspects "nixos"}"
          compare "任意の機能 (darwin)" "$(listed darwin)" "${aspects "darwin"}"
          compare "Hosts" "$(sed -n '/^## Hosts/,/^## /s/^| `\([^`]*\)`.*/\1/p' README.md)" "${lib.concatStringsSep "\n" (lib.attrNames allConfigs)}"
          compare "modules/ 直下" "$(sed -n '/^### ディレクトリ/,/^### /s/^  - `\([^`]*\)`.*/\1/p' README.md)" "$(ls -p modules)"
          [ "$status" -eq 0 ] || exit 1
        '';

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
