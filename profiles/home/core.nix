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
      home.shell
      home."shell.fish"
      home."shell.zsh"
      home."tool.cli"
      home."tool.claude-code"
      home."tool.dev-service"
      home."tool.docker"
      home."tool.docs"
      home."tool.git"
      home."tool.tff"
      home."tool.tmux"
    ];
  };
}
