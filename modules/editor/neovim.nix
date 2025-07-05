{ dotfilesPath, ... }:

{
  home.file.".config/nvim".source = (dotfilesPath + /lazyvim);

  programs.neovim = {
    enable = true;
  };

  programs.zsh.shellAliases = {
    v = "nvim";
  };
}
