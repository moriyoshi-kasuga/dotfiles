{ inputs, ... }:

{
  flake.modules.homeManager."tool.claude-code.basic" =
    {
      pkgs,
      lib,
      config,
      ...
    }:
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

      preToolUseGuard = pkgs.writeShellApplication {
        name = "claude-pre-tool-use-guard";
        runtimeInputs = [
          pkgs.jq
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
            装飾的なUnicode記号（現行の記号例のまま）は、英語・日本語を問わず使わない。
            使ってよいのはASCII記号（`-`・`:`など）と、
            日本語の通常の全角句読点・括弧類（「」『』、。・など、これらに限らない）だけ。
            禁止した記号を`--`のようにASCII文字の組み合わせで模倣することも同様に禁止する。

            対象はソースコード、コミットメッセージ、コメント、README、ドキュメント、記事、PR本文、issueなど、
            成果物として残るものや他人が読むもの全般。

            ただし次の出力に限っては、この制限を適用しない:
            - ユーザーへのチャット応答
            - agent向けの資料（CLAUDE.md、AGENTS.md、skill、memory）
            - /tmp など、外部に公開しない一時ファイル

            どちらに当てはまるか迷う場合は、制限する側として扱う。
          '';
        };
        settings = {
          disableArtifact = true;
          diffTool = "terminal";
          attribution = {
            commit = "";
            pr = "";
          };
          permissions = {
            defaultMode = "auto";
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
            deny =
              map (c: "Bash(${c} *)") guardedCommands
              ++ map (g: "Read(${g})") guardedReads
              ++ map (g: "Edit(${g})") guardedEdits;
          };
          cleanupPeriodDays = 30;
          hooks = {
            PreToolUse = [
              {
                matcher = "Bash|Read|Edit|MultiEdit|Write|NotebookEdit";
                hooks = [
                  {
                    type = "command";
                    command = lib.getExe preToolUseGuard;
                  }
                ];
              }
            ];
            Notification = [
              {
                matcher = "permission_prompt";
                hooks = [
                  {
                    type = "command";
                    command = "msg=$(${pkgs.jq}/bin/jq -r '.message // \"Require operation\"'); /etc/profiles/per-user/${config.home.username}/bin/notify \"$msg\" 'Claude Code'";
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
            DISABLE_ERROR_REPORTING = "1";
          };
        };
      };
    };
}
