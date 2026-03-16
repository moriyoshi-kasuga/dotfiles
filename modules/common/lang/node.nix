{
  pkgs,
  mkModule,
  ...
}:

mkModule {
  name = "lang.node";
  inheritModule = "lang";
  homeModule = {
    home.packages = with pkgs; [
      nodejs
      bun
    ];

    programs.zsh.envExtra = ''
      export PATH="$HOME/.bun/bin:$PATH"
    '';

    programs.fish.shellInit = ''
      fish_add_path $HOME/.bun/bin
    '';
  };
}
