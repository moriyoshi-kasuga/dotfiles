{
  config,
  lib,
  vars,
  ...
}:

{
  catppuccin.nvim.enable = false;

  programs.neovim = {
    enable = true;
  };

  programs.zsh.shellAliases = {
    v = "nvim";
  };
}
