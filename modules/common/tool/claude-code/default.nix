{ inputs, ... }:

{
  flake.modules.homeManager."tool.claude-code" =
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

      # Claude Code only loads skills/<name>/SKILL.md, so nested category
      # directories are walked and flattened by skill directory name.
      findSkills =
        dir:
        lib.concatMap (
          name:
          let
            path = "${dir}/${name}";
          in
          if builtins.pathExists "${path}/SKILL.md" then
            [ (lib.nameValuePair name path) ]
          else
            findSkills path
        ) (lib.attrNames (lib.filterAttrs (_: type: type == "directory") (builtins.readDir dir)));

      # The skills import packages/core/dist and try to `pnpm install` into the
      # plugin root when it is missing, which fails in the read-only store, so
      # core is prebuilt here. Hooks call bare `node`, pinned to an absolute
      # path so they work without nodejs on PATH.
      understandAnythingPlugin = pkgs.stdenv.mkDerivation (finalAttrs: {
        pname = "understand-anything-plugin";
        version = "2.9.7";
        src = "${inputs.Egonex-AI-Understand-Anything}/understand-anything-plugin";
        pnpmDeps = pkgs.fetchPnpmDeps {
          inherit (finalAttrs) pname version src;
          pnpm = pkgs.pnpm_10;
          fetcherVersion = 3;
          hash = "sha256-Zq6rdL+DJ3J9fm5yNPtHPygHTfIbOSLaX3M5emat+RY=";
        };
        nativeBuildInputs = [
          pkgs.nodejs
          pkgs.pnpmConfigHook
          pkgs.pnpm_10
        ];
        buildPhase = ''
          runHook preBuild
          pnpm --filter @understand-anything/core build
          runHook postBuild
        '';
        installPhase = ''
          runHook preInstall
          sed -i 's|\bnode |${lib.getExe pkgs.nodejs} |g' hooks/hooks.json
          cp -r . $out
          runHook postInstall
        '';
      });

      skillList =
        lib.concatMap findSkills [
          # engineering and productivity come from the plugin manifest.
          "${inputs.mattpocock-skills}/skills/in-progress"
          "${inputs.mattpocock-skills}/skills/misc"
          "${inputs.mattpocock-skills}/skills/engineering"
          "${inputs.mattpocock-skills}/skills/productivity"
          "${inputs.anthropic-skills}/skills"
        ]
        ++ [ (lib.nameValuePair "rust-skills" "${inputs.leonardomso-rust-skills}") ];

      duplicateSkills = lib.attrNames (
        lib.filterAttrs (_: v: builtins.length v > 1) (lib.groupBy (s: s.name) skillList)
      );
    in
    {
      assertions = [
        {
          assertion = duplicateSkills == [ ];
          message = "duplicate Claude Code skill names: ${lib.concatStringsSep ", " duplicateSkills}";
        }
      ];

      programs.claude-code = {
        enable = true;
        package = pkgs.claude-code;
        commandsDir = ../../../../commands;
        skills = lib.listToAttrs skillList;
        plugins = {
          inherit (inputs) mattpocock-skills;
          superpowers = inputs.obra-superpowers;
          understand-anything = understandAnythingPlugin;
        };
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
            CLAUDE_CODE_TMUX_TRUECOLOR = "1";
          };
        };
      };
    };
}
