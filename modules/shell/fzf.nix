_:

{
  flake.modules.homeManager.base =
    { config, ... }:
    let
      c =
        (builtins.fromJSON (builtins.readFile "${config.catppuccin.sources.palette}/palette.json"))
        .${config.catppuccin.flavor}.colors;
    in
    {
      programs.fzf = {
        enable = true;
        tmux = {
          enableShellIntegration = true;
          shellIntegrationOptions = [
            "-p 55%,65%"
          ];
        };
      };

      # fzf は catppuccin/nix に任せず palette から組み立てる: 背景を端末の透過に合わせるため
      # bg:-1 / fg:-1 が必要で、モジュール側のテーマだと上書きされてしまう。
      catppuccin.fzf.enable = false;

      home.sessionVariables = {
        FZF_DEFAULT_COMMAND = "fd --hidden --type l --type f --type d --exclude .git --exclude .cache";
        FZF_DEFAULT_OPTS = "--color=bg:-1,bg+:-1,hl:${c.red.hex},hl+:${c.red.hex},fg:-1,fg+:-1,header:-1,info:${c.mauve.hex},pointer:${c.rosewater.hex},marker:${c.rosewater.hex},prompt:${c.mauve.hex},spinner:${c.rosewater.hex} --prompt='λ ' --pointer='▶' --marker='✓'";
      };
    };
}
