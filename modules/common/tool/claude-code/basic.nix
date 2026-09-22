{ inputs, ... }:

{
  flake.modules.homeManager."tool.claude-code.basic" =
    {
      pkgs,
      config,
      ...
    }:
    {
      imports = [ inputs.agent-skills-nix.homeManagerModules.default ];

      programs.agent-skills = {
        enable = true;
        sources = {
          mattpocock-engineering = {
            input = "mattpocock-skills";
            subdir = "skills/engineering";
          };
          mattpocock-in-progress = {
            input = "mattpocock-skills";
            subdir = "skills/in-progress";
          };
          mattpocock-misc = {
            input = "mattpocock-skills";
            subdir = "skills/misc";
          };
          mattpocock-productivity = {
            input = "mattpocock-skills";
            subdir = "skills/productivity";
          };
        };
        skills.enableAll = true;
        targets.claude.enable = true;
      };

      programs.claude-code = {
        enable = true;
        package = pkgs.claude-code;
        commandsDir = ../../../../commands;
        rules = {
          write-style = ''
            装飾的なUnicode記号（emdash「—」・波ダッシュ「〜」・三点リーダー「…」・矢印「→」など、これらに限らない）は、
            英語・日本語を問わずいかなる出力でも使わない。使ってよいのはASCII記号（`-`・`+`など）と、
            日本語の通常の全角句読点・括弧類（「」『』、。・など、これらに限らない）だけ。
            禁止した記号を`--`のようにASCII文字の組み合わせで模倣することも同様に禁止する
          '';
        };
        settings = {
          disableArtifact = true;
          diffTool = "terminal";
          permissions = {
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
              "Bash(nixos-rebuild switch *)"
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
