{
  pkgs,
  mkModule,
  lib,
  ...
}:

mkModule {
  name = "tool.claude-code.basic";
  inheritModule = "tool.claude-code";
  homeModule =
    let
      commandList = map (x: {
        name = ".claude/skills/" + (lib.removeSuffix ".md" x) + "/SKILL.md";
        value.source = ./commands + ("/" + x);
      }) (builtins.attrNames (builtins.readDir ./commands));
    in
    {
      home.packages = with pkgs; [
        claude-code
      ];
      home.file = builtins.listToAttrs commandList;
    };
}
