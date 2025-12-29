{ pkgs, vars, ... }:

let
  ai = vars.askAI;
  script =
    if ai == null then
      builtins.abort "askAI is not set in the environment"
    else if ai == "claude" then
      ''
        claude -p "$1"
      ''
    else if ai == "copilot" then
      ''
        copilot --model gpt-5-mini -p "$1"
      ''
    else if ai == "gemini" then
      ''
        gemini -m "gemini-2.5-pro" -p "$1"
      ''
    else
      builtins.abort "Unknown AI model: ${ai}";
in
{
  home.packages = with pkgs; [
    (writeShellScriptBin "ask" script)
  ];
}
