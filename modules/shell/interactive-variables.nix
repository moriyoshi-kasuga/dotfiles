_:

{
  # 開発用の環境変数 (LD_LIBRARY_PATH や CFLAGS など) は対話シェルにだけ渡す。
  # home.sessionVariables に入れると、niri-session がログインシェルの環境を丸ごと
  # systemd --user に取り込むため、compositor や GUI アプリにまで漏れて
  # 別の nixpkgs でビルドされたバイナリが違うライブラリを読み込んでしまう。
  flake.modules.homeManager.base =
    { config, lib, ... }:
    let
      vars = config.shell.interactiveVariables;
    in
    {
      options.shell.interactiveVariables = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        description = "Environment variables exported only in interactive shells.";
      };

      config.programs.fish.interactiveShellInit = lib.concatStrings (
        lib.mapAttrsToList (name: value: "set -gx ${name} ${lib.escapeShellArg value}\n") vars
      );
    };
}
