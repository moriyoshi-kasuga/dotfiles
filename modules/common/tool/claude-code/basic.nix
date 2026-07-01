{
  pkgs,
  mkModule,
  lib,
  username,
  ...
}:

mkModule {
  name = "tool.claude-code.basic";
  inheritModule = "tool.claude-code";
  homeModule =
    let
      commandFiles = builtins.attrNames (builtins.readDir ./commands);
      allowSkills = map (x: "Skill(${lib.removeSuffix ".md" x})") commandFiles;
      commandList = map (x: {
        name = ".claude/skills/" + (lib.removeSuffix ".md" x) + "/SKILL.md";
        value.source = ./commands + ("/" + x);
      }) commandFiles;

      settings = {
        permissions = {
          disableArtifact = true;
          disableAutoMode = "disable";
          allow = [
            # filesystem read-only
            "Bash(ls *)"
            "Bash(find *)"
            "Bash(fd *)"
            "Bash(cat *)"
            "Bash(head *)"
            "Bash(tail *)"
            "Bash(bat *)"
            "Bash(echo *)"
            "Bash(pwd)"
            "Bash(wc *)"
            "Bash(sort *)"
            "Bash(uniq *)"
            "Bash(diff *)"
            "Bash(stat *)"
            "Bash(du *)"
            "Bash(tokei *)"
            "Bash(grep *)"
            "Bash(rg *)"
            "Bash(fzf *)"
            "Bash(eza *)"
            "Bash(jq *)"
            "Bash(which *)"
            "Bash(tldr *)"
            "Bash(nix search *)"
            # git read-only
            "Bash(git status *)"
            "Bash(git log *)"
            "Bash(git diff *)"
            "Bash(git show *)"
            "Bash(git branch)"
            "Bash(git stash list)"
            "Bash(gh pr diff *)"
            # cargo (rust)
            "Bash(cargo build *)"
            "Bash(cargo clippy *)"
            "Bash(cargo fmt *)"
            "Bash(cargo check *)"
            "Bash(cargo test *)"
            "Bash(cargo nextest *)"
            "Bash(cargo doc *)"
            # js and ts
            "Bash(npm run lint)"
            "Bash(deno run lint)"
            "Bash(npm run lint:fix)"
            "Bash(deno run lint:fix)"
            "Bash(npm run check)"
            "Bash(deno run check)"
            "Bash(npm run format)"
            "Bash(deno run format)"
            # scala
            "Bash(mill *.compile)"
            "Bash(mill *.assembly)"
            "Bash(mill *.test)"
            "Bash(mill *.fix)"
            "Bash(mill mill.scalalib.scalafmt/)"
          ]
          ++ allowSkills;
          deny = [
            "Task"
            "Bash(terraform *)"
            "Bash(sudo *)"
            "Bash(chmod 777 *)"
            "Bash(cargo publish *)"
            "Read(.env*)"
            "Read(id_rsa)"
            "Read(id_ed25519)"
            "Write(.env)"
            "Write(.env *)"
            "Write(**/secrets/**)"
          ];
        };
        cleanupPeriodDays = 30;
        hooks = {
          Notification = [
            {
              matcher = "permission_prompt";
              hooks = [
                {
                  type = "command";
                  command = "${pkgs.jq}/bin/jq -r '.message // \"Require operation\"' | ${pkgs.findutils}/bin/xargs -I {} /etc/profiles/per-user/${username}/bin/notify {} 'Claude Code'";
                }
              ];
            }
          ];
          Stop = [
            {
              hooks = [
                {
                  type = "command";
                  command = "/etc/profiles/per-user/${username}/bin/notify 'Task completed' 'Claude Code'";
                }
              ];
            }
          ];
        };
        tui = "default";
        language = "Japanese";
        env = {
          IS_DEMO = 1;
        };
      };
    in
    {
      programs.claude-code = {
        enable = true;
        package = pkgs.claude-code;
      };
      home.file = (builtins.listToAttrs commandList) // {
        ".claude/settings.json" = {
          force = true;
          text = builtins.toJSON settings;
        };
      };
    };
}
