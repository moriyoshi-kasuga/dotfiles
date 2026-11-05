_:

{
  flake.modules.homeManager.base =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      yaml = pkgs.formats.yaml { };
    in
    {
      home.packages = [ pkgs.process-compose ];

      # process-compose は TUI で選んだ theme や sort を settings.yaml に書き戻すが、
      # ここで固定するので書き戻しは失敗し、log に残るだけになる
      xdg.configFile."process-compose/settings.yaml".source =
        yaml.generate "process-compose-settings.yaml"
          {
            theme = "Catppuccin ${lib.toSentenceCase config.catppuccin.flavor}";
          };

      # 一文字の shortcut は process 一覧と log のどちらに focus があっても効く。
      # j/k/g/G は一覧と log の移動に、大文字は一覧の sort に使われているので割り当てない
      xdg.configFile."process-compose/shortcuts.yaml".source =
        yaml.generate "process-compose-shortcuts.yaml"
          {
            shortcuts = lib.mapAttrs (_: shortcut: { inherit shortcut; }) {
              help = "?";
              quit = "q";
              process_start = "s";
              process_stop = "x";
              process_restart = "r";
              process_info = "i";
              edit_process = "e";
              log_follow = "f";
              log_wrap = "w";
              log_select = "v";
            };
          };
    };
}
