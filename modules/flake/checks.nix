{ inputs, ... }:

{
  perSystem =
    { system, ... }:
    let
      pkgs = import inputs.nixpkgs { inherit system; };

      devTools = with pkgs; [
        nixfmt
        statix
        deadnix
        stylua
        shellcheck
      ];
    in
    {
      formatter = pkgs.nixfmt-tree;

      checks.lint =
        pkgs.runCommand "lint"
          {
            nativeBuildInputs = devTools;
            src = inputs.self;
          }
          ''
            cd "$src"
            statix check .
            deadnix --fail flake.nix modules
            nixfmt --check
            stylua --check --indent-type Spaces --indent-width 2 nvim-config
            shellcheck init.sh
            touch $out
          '';

      devShells.default = pkgs.mkShell {
        packages = devTools ++ [ pkgs.nixd ];
      };
    };
}
