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
      # commands/ 直下は「1ファイル = 1スキル」(name.md -> skills/name/SKILL.md) だが、
      # 参照ファイル（言語別設計方針など）を伴うスキルはディレクトリで表現する
      # (commands/name/ 配下のファイルをそのまま skills/name/ 直下にコピーする。
      # エントリポイントは commands/name/SKILL.md という名前で置く)。
      commandEntries = builtins.readDir ./commands;
      skillNames = lib.mapAttrsToList (
        name: type: if type == "directory" then name else lib.removeSuffix ".md" name
      ) commandEntries;
      allowSkills = map (x: "Skill(${x})") skillNames;
      commandList = lib.concatLists (
        lib.mapAttrsToList (
          name: type:
          if type == "directory" then
            map (file: {
              name = ".claude/skills/${name}/${file}";
              value.source = ./commands + "/${name}/${file}";
            }) (builtins.attrNames (builtins.readDir (./commands + "/${name}")))
          else
            [
              {
                name = ".claude/skills/" + (lib.removeSuffix ".md" name) + "/SKILL.md";
                value.source = ./commands + ("/" + name);
              }
            ]
        ) commandEntries
      );

      settings = {
        permissions = {
          disableArtifact = true;
          disableAutoMode = "disable";
          allow = [
            "Read(//tmp/**)"
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
            "Bash(git push *)"
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
          CLAUDE_CODE_SHELL = "${pkgs.bash}/bin/bash";
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
