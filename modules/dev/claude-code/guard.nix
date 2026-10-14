{ lib, ... }:

let
  # Single source for both permissions.deny and the PreToolUse guard hook.
  # Aliases are listed too (gh pr new, docker image push). The guard also blocks `gh api` writes.
  guardedCommands = [
    # privilege escalation
    "sudo"
    "su"
    "doas"
    "run0"
    "pkexec"
    # system activation
    "nixos-rebuild switch"
    "nixos-rebuild boot"
    "nixos-rebuild test"
    "darwin-rebuild switch"
    "darwin-rebuild activate"
    "terraform"
    # publishing
    "git push"
    "cargo publish"
    "cargo release"
    "cargo yank"
    "cargo owner"
    "npm publish"
    "pnpm publish"
    "deno publish"
    "docker push"
    "docker image push"
    "docker compose push"
    # GitHub writes
    "gh pr create"
    "gh pr new"
    "gh pr merge"
    "gh pr comment"
    "gh pr review"
    "gh pr close"
    "gh pr edit"
    "gh issue create"
    "gh issue new"
    "gh issue comment"
    "gh issue close"
    "gh issue edit"
    "gh release create"
    "gh release new"
    "gh repo create"
    "gh repo new"
    "gh repo delete"
    "gh gist create"
    "gh gist new"
    "gh workflow run"
    "gh secret set"
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
