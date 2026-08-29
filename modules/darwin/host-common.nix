{ inputs, ... }:

let
  darwin = inputs.self.modules.darwin;
in
{
  flake.modules.darwin."host.common" = {
    imports = [
      darwin.base
      darwin.aerospace
      darwin.dock
      darwin.finder
      darwin.homebrew
      darwin."ios-dev"
      darwin.tailscale
      darwin.font
      darwin."shell.fish"
      darwin."shell.zsh"
      darwin."terminal.wezterm"
      darwin."tool.docker"
    ];
  };
}
