{ inputs, ... }:

{
  flake.modules.homeManager.shell =
    { pkgs, config, ... }:
    let
      inherit (config.catppuccin) flavor;
      palette =
        (builtins.fromJSON (builtins.readFile "${inputs.catppuccin-palette}/palette.json"))
        .${flavor}.colors;
    in
    {
      home.packages = with pkgs; [
        # use latest version
        bash
      ];

      programs = {
        starship = {
          enable = true;
          enableZshIntegration = false;
          settings = {
            add_newline = false;

            package.disabled = true;

            java.disabled = true;
            kotlin.disabled = true;
            gradle.disabled = true;
            scala.disabled = true;
            aws.disabled = true;

            palette = "catppuccin_${flavor}";
            palettes."catppuccin_${flavor}" = builtins.mapAttrs (_: color: color.hex) palette;
          };
        };
        direnv = {
          enable = true;
          enableZshIntegration = false;
          nix-direnv.enable = true;
        };
        zoxide = {
          enableZshIntegration = false;
          enable = true;
        };
        eza.enable = true;
        fzf = {
          enable = true;
          enableZshIntegration = false;
          tmux = {
            enableShellIntegration = true;
            shellIntegrationOptions = [
              "-p 55%,65%"
            ];
          };
        };
      };

      # fzf は catppuccin/nix に任せず手書き: 背景を端末の透過に合わせるため
      # bg:-1 / fg:-1 が必要で、モジュール側のテーマだと上書きされてしまう。
      catppuccin.fzf.enable = false;

      # starship も catppuccin/nix に任せず palette を直接渡す: モジュール側は IFD を使うため、
      # 他プラットフォームの構成を評価する nix flake check が失敗する。
      # https://github.com/catppuccin/nix/issues/392
      catppuccin.starship.enable = false;

      home.sessionVariables = {
        _ZO_EXCLUDE_DIRS = "$HOME:/tmp/*:/var/*:/nix/*:/mnt/*";
        FZF_DEFAULT_COMMAND = "fd --hidden --type l --type f --type d --exclude .git --exclude .cache";
        FZF_DEFAULT_OPTS = "--color=bg:-1,bg+:-1,hl:#ed8796,hl+:#ed8796,fg:-1,fg+:-1,header:-1,info:#c6a0f6,pointer:#f4dbd6,marker:#f4dbd6,prompt:#c6a0f6,spinner:#f4dbd6 --prompt='λ ' --pointer='▶' --marker='✓'";
      };

      home.shellAliases = {
        ".." = "cd ../";
        "..." = "cd ../../";
        e = "exit";

        l = "eza";
        ll = "eza --long --git";
        la = "eza --all";
        lsa = "eza --all --long";
        lt = "eza --tree --git-ignore";
      };
    };
}
