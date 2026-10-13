{ lib, ... }:

let
  # Single source for both permissions.deny and the PreToolUse guard hook.
  guardedCommands = [
    "git push"
    "terraform"
    "sudo"
    "cargo publish"
    "nixos-rebuild switch"
    "gh pr create"
    "gh issue create"
  ];
  guardedReads = [
    ".env"
    ".env.*"
  ];
  guardedEdits = [
    ".env"
    ".env.*"
  ];

  mkGuard =
    pkgs:
    pkgs.writeShellApplication {
      name = "claude-pre-tool-use-guard";
      runtimeInputs = [
        pkgs.jq
        pkgs.shfmt
        pkgs.gnugrep
        pkgs.gnused
        pkgs.coreutils
      ];
      runtimeEnv = {
        GUARDED_COMMANDS = lib.concatLines guardedCommands;
        GUARDED_READS = lib.concatLines guardedReads;
        GUARDED_EDITS = lib.concatLines guardedEdits;
      };
      text = builtins.readFile ./pre-tool-use-guard.sh;
    };
in
{
  perSystem =
    { pkgs, ... }:
    {
      checks.claude-guard = pkgs.runCommand "claude-guard" { nativeBuildInputs = [ pkgs.jq ]; } ''
        bash ${./pre-tool-use-guard-test.sh} ${lib.getExe (mkGuard pkgs)}
        touch "$out"
      '';
    };

  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.claude-code.settings = {
        permissions.deny =
          map (c: "Bash(${c} *)") guardedCommands
          ++ map (g: "Read(${g})") guardedReads
          ++ map (g: "Edit(${g})") guardedEdits;

        hooks.PreToolUse = [
          {
            matcher = "Bash|Read|Edit|MultiEdit|Write|NotebookEdit";
            hooks = [
              {
                type = "command";
                command = lib.getExe (mkGuard pkgs);
              }
            ];
          }
        ];
      };
    };
}
