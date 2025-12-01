{
  config,
  lib,
  vars,
  ...
}:

{
  catppuccin.nvim.enable = false;

  home.activation.nvim = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ln -sfn ${vars.dotfilesRepoDir}/dotfiles/lazyvim ${config.home.homeDirectory}/.config/nvim
  '';

  programs.neovim = {
    enable = true;
  };

  programs.zsh.shellAliases = {
    v = "nvim";
  };
}
