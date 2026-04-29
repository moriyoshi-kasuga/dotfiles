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

      settings = {
        permissions = {
          disableAutoMode = "disable";
          allow = [
            # filesystem read-only
            "Bash(ls)"
            "Bash(ls *)"
            "Bash(find *)"
            "Bash(fd *)"
            "Bash(cat *)"
            "Bash(head *)"
            "Bash(tail *)"
            "Bash(bat *)"
            "Bash(echo *)"
            "Bash(pwd)"
            "Bash(wc *)"
            "Bash(sort *)"
            "Bash(uniq *)"
            "Bash(diff *)"
            "Bash(stat *)"
            "Bash(du *)"
            # search
            "Bash(grep *)"
            "Bash(rg *)"
            "Bash(fzf *)"
            # modern alternatives
            "Bash(eza *)"
            # git read-only
            "Bash(git status)"
            "Bash(git status *)"
            "Bash(git log)"
            "Bash(git log *)"
            "Bash(git diff)"
            "Bash(git diff *)"
            "Bash(git show)"
            "Bash(git show *)"
            "Bash(git branch)"
            "Bash(git stash list)"
          ];
          deny = [
            "Bash(sudo *)"
            "Bash(rm -rf *)"
            "Bash(chmod 777 *)"
            "Read(.env*)"
            "Read(id_rsa)"
            "Read(id_ed25519)"
            "Write(.env)"
            "Write(.env *)"
            "Write(**/secrets/**)"
          ];
        };
        cleanupPeriodDays = 30;
      };
    in
    {
      home.packages = with pkgs; [
        claude-code
      ];
      home.file = (builtins.listToAttrs commandList) // {
        ".claude/settings.json".text = builtins.toJSON settings;
      };
    };
}
