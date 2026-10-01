_:

{
  flake.modules.homeManager.base = {
    programs.fzf = {
      enable = true;
      enableZshIntegration = false;
      tmux = {
        enableShellIntegration = true;
        shellIntegrationOptions = [
          "-p 55%,65%"
        ];
      };
    };

    # fzf は catppuccin/nix に任せず手書き: 背景を端末の透過に合わせるため
    # bg:-1 / fg:-1 が必要で、モジュール側のテーマだと上書きされてしまう。
    catppuccin.fzf.enable = false;

    home.sessionVariables = {
      FZF_DEFAULT_COMMAND = "fd --hidden --type l --type f --type d --exclude .git --exclude .cache";
      FZF_DEFAULT_OPTS = "--color=bg:-1,bg+:-1,hl:#ed8796,hl+:#ed8796,fg:-1,fg+:-1,header:-1,info:#c6a0f6,pointer:#f4dbd6,marker:#f4dbd6,prompt:#c6a0f6,spinner:#f4dbd6 --prompt='λ ' --pointer='▶' --marker='✓'";
    };
  };
}
