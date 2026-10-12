_:

{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      imports = [
        ./_delta.nix
        ./_lazygit.nix
      ];

      programs.git = {
        enable = true;

        settings = {
          init.defaultBranch = "main";
          merge.conflictStyle = "zdiff3";
          push.default = "current";
          pull.rebase = true;
          fetch.prune = true;
          rebase.autostash = true;
          diff.algorithm = "histogram";
          rerere.enabled = true;
          branch.sort = "-committerdate";
        };

        # user.name / email などマシンごとの設定はリポジトリに入れず、このファイルに書く。
        # ファイルが無ければ git は読み飛ばす。
        includes = [ { path = "~/.config/git/local"; } ];
      };

      home.packages = with pkgs; [
        gh
        git-filter-repo
      ];

      home.shellAliases = {
        g = "git";
        gb = "git branch";
        gbd = "git branch -d";
        gcm = "git commit -m";
        gc = "git switch";
        gcb = "git switch -c";
        gl = "git log --oneline --graph --decorate";
      };

      programs.fish.interactiveShellInit = builtins.readFile ./worktree.fish;
    };
}
