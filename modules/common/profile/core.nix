{ inputs, ... }:

let
  home = inputs.self.modules.homeManager;
in
{
  flake.modules.homeManager."profile.core" = {
    imports = [
      home.base
      home."editor.neovim"
      home."editor.vim"
      home.library
      home."shell.basic"
      home."shell.fish"
      home."shell.zsh"
      home."terminal.wezterm"
      home."tool.basic"
      home."tool.claude-code.basic"
      home."tool.docker"
      home."tool.git.basic"
      home."tool.git.delta"
      home."tool.git.lazygit"
      home."tool.tff"
      home."tool.tmux"
      home.wallpaper
    ];
  };
}
