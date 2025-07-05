{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (writeShellScriptBin "pbpaste" ''
      win32yank.exe -o --lf
    '')
    (writeShellScriptBin "pbcopy" ''
      win32yank.exe -i --crlf
    '')
  ];
}
