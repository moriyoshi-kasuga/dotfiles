{
  mkModule,
  pkgs,
  username,
  ...
}:

mkModule {
  name = "darwin.dock";
  inheritModule = "darwin";
  darwinHomeModule =
    { ... }:
    let
      wallpapers = pkgs.fetchFromGitHub {
        owner = "orangci";
        repo = "walls";
        rev = "f61033f92cc24c60aebd306e113eb2aacd498c0f";
        hash = "sha256-2/dZGA5IoYANTUlR0I/GUtO8GeOlzAHouyjtKuVvcl4=";
      };
    in
    {
      home.file.".local/bin/wallpaper-rotate".text = ''
        #!/usr/bin/env bash
        CACHE_FILE="$HOME/.cache/wallpaper-used"
        mkdir -p "$(dirname "$CACHE_FILE")"
        touch "$CACHE_FILE"

        # 全ファイルを検索してソート
        ALL_FILES=$(fd . "${wallpapers}" -d 1 -t f -e jpg -e png | sort)

        # 未使用のファイルのみを抽出 (comm -23 は 1つ目のリストにのみ存在する行を表示)
        REMAINING=$(comm -23 <(echo "$ALL_FILES") <(sort "$CACHE_FILE"))

        # 残りがない場合はキャッシュをクリアして全リストを使用
        if [[ -z "$REMAINING" ]]; then
          : >"$CACHE_FILE"
          REMAINING="$ALL_FILES"
        fi

        # ランダムに1つ選択
        FILE=$(shuf -n 1 <<<"$REMAINING")

        if [[ -n "$FILE" ]]; then
          /usr/bin/osascript <<EOF
            tell application "System Events"
              set picture of every desktop to "$FILE"
            end tell
        EOF
          # 使用済みとしてキャッシュに追加
          echo "$FILE" >>"$CACHE_FILE"
        fi
      '';

      home.file.".local/bin/wallpaper-rotate".executable = true;

      launchd.agents.wallpaper-rotate = {
        enable = true;

        config = {
          ProgramArguments = [ "/Users/${username}/.local/bin/wallpaper-rotate" ];
          StartInterval = 5 * 60;
          RunAtLoad = true;
        };
      };
    };
  darwinModule = {
    system.defaults.dock = {
      autohide = true;
      show-recents = false;
      tilesize = 50;
      magnification = true;
      largesize = 64;
      orientation = "bottom";
      mineffect = "scale";
      launchanim = false;
    };
    system.defaults.spaces.spans-displays = true;
    system.defaults.NSGlobalDomain._HIHideMenuBar = false;
  };
}
