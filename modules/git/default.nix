{ dotfilesPath, ... }:

{
  programs.git = {
    enable = true;
  };

  home.file.".gitconfigs".source = dotfilesPath + /.gitconfigs;
}
