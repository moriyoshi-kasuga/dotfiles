_:

{
  flake.modules.homeManager."tool.claude-code.basic" =
    {
      pkgs,
      config,
      ...
    }:
    {
      programs.claude-code = {
        enable = true;
        package = pkgs.claude-code;
        commandsDir = ../../../../skills;
        settings = {
          disableArtifact = true;
          permissions = {
            disableAutoMode = "disable";
            additionalDirectories = [
              "/nix/store"
            ];
            allow = [
              "Read(//tmp/**)"
              # filesystem read-only
              "Bash(date *)"
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
              "Bash(nix flake check *)"
              # git read-only
              "Bash(git status *)"
              "Bash(git log *)"
              "Bash(git diff *)"
              "Bash(git show *)"
              "Bash(git branch)"
              "Bash(git stash list)"
              "Bash(gh pr diff *)"
              # cargo (rust)
              "Bash(rustc *)"
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
            ];
            deny = [
              "Bash(git push *)"
              "Bash(terraform *)"
              "Bash(sudo *)"
              "Bash(chmod 777 *)"
              "Bash(cargo publish *)"
              "Read(.env*)"
              "Read(id_rsa)"
              "Read(id_ed25519)"
              "Edit(.env)"
              "Edit(.env.*)"
              "Edit(**/secrets/**)"
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
                    command = "${pkgs.jq}/bin/jq -r '.message // \"Require operation\"' | ${pkgs.findutils}/bin/xargs -I {} /etc/profiles/per-user/${config.home.username}/bin/notify {} 'Claude Code'";
                  }
                ];
              }
            ];
            Stop = [
              {
                hooks = [
                  {
                    type = "command";
                    command = "/etc/profiles/per-user/${config.home.username}/bin/notify 'Task completed' 'Claude Code'";
                  }
                ];
              }
            ];
          };
          tui = "fullscreen";
          bindings = [
            # {
            #   context = "Chat";
            #   bindings = {
            #     "ctrl+j" = null;
            #   };
            # }
            {
              context = "Scroll";
              bindings = {
                "ctrl+d" = "scroll:lineDown";
                "ctrl+u" = "scroll:lineUp";
              };
            }
          ];
          language = "Japanese";
          env = {
            CLAUDE_CODE_SHELL = "${pkgs.bash}/bin/bash";
          };
        };
      };
    };
}
