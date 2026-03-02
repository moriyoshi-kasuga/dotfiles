{ mkEnableOption, ... }:

{
  options.modules.editor.enable = mkEnableOption "enable editor settings";

  imports = [
    ./neovim
    ./vim
  ];
}
