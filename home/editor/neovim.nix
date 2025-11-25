{
  config,
  lib,
  vars,
  ...
}:

{
  catppuccin.nvim.enable = false;

  home.activation.nvim = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -e ${config.home.homeDirectory}/.config/nvim ]; then
      ln -s ${vars.dotfilesRepoDir}/dotfiles/lazyvim ${config.home.homeDirectory}/.config/nvim
    fi
  '';

  programs.neovim = {
    enable = true;
  };

  programs.zsh.shellAliases = {
    v = "nvim";
  };
}
