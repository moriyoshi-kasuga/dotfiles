{
  pkgs,
  mkModule,
  ...
}:

mkModule {
  name = "lang.node";
  module = {
    home.packages = with pkgs; [
      nodejs_latest
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
