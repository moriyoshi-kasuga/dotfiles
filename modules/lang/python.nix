_:

{
  flake.modules.homeManager."lang.python" =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        python3
        chromedriver
      ];

      programs.uv = {
        enable = true;
        # Nix の python を元にした venv は、nixpkgs の python がマイナー更新されると壊れる。
        # プロジェクトの python は uv 管理のものだけを使う
        settings.python-preference = "only-managed";
      };

      programs.neovim.extraPackages = with pkgs; [
        ty
        ruff
        # nvim-dap-python が起動する debugpy-adapter
        python3Packages.debugpy
      ];
    };
}
