{ inputs, ... }:

let
  nixpkgs.overlays = [ inputs.nix-claude-code.overlays.default ];
in
{
  flake.modules.nixos.base = { inherit nixpkgs; };
  flake.modules.darwin.base = { inherit nixpkgs; };

  flake.modules.homeManager.base =
    { pkgs, config, ... }:
    let
      notify = "${config.home.profileDirectory}/bin/notify";
    in
    {
      programs.claude-code = {
        enable = true;
        package = pkgs.claude-code;
        rules = {
          write-style = ''
            装飾的なUnicode記号（em dash「—」・波ダッシュ「〜」・三点リーダー「…」・矢印「→」など、これらに限らない）は、
            英語・日本語を問わず使わない。
            使ってよいのはASCII記号（`-`・`:`など）と、
            日本語の通常の全角句読点・括弧類（「」『』、。・など、これらに限らない）だけ。
            禁止した記号を`--`のようにASCII文字の組み合わせで模倣することも同様に禁止する。

            対象はソースコード、コミットメッセージ、コメント、README、ドキュメント、記事、PR本文、issueなど、
            成果物として残るものや他人が読むもの全般。

            ただし次の出力に限っては、この制限を適用しない:
            - ユーザーへのチャット応答
            - agent向けの資料（CLAUDE.md、AGENTS.md、skill、memory）
            - /tmp など、外部に公開しない一時ファイル

            また、ユーザーが承知のうえで記号を求めている次の場合は、その記号を使ってよい:
            - ユーザーがその書き方を指示した
            - 従うべきテンプレート（PRテンプレート、issueテンプレートなど）にその記号が含まれている
            - プロジェクトやチームの規約・書式としてその記号が定められている
            許可されるのは指示・テンプレート・書式が求める箇所だけで、それ以外の自分で書く文章には制限を適用する。

            どちらに当てはまるか迷う場合は、制限する側として扱う。
          '';
        };
        settings = {
          disableArtifact = true;
          diffTool = "terminal";
          enabledPlugins = {
            "cc-plugin-diff@builtin" = false;
          };
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
          };
          cleanupPeriodDays = 30;
          hooks = {
            Notification = [
              {
                matcher = "permission_prompt";
                hooks = [
                  {
                    type = "command";
                    command = "msg=$(${pkgs.jq}/bin/jq -r '.message // \"Require operation\"'); ${notify} \"$msg\" 'Claude Code'";
                  }
                ];
              }
            ];
            Stop = [
              {
                hooks = [
                  {
                    type = "command";
                    command = "${notify} 'Task completed' 'Claude Code'";
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
