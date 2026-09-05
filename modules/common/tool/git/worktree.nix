_:

{
  flake.modules.homeManager."tool.git.worktree" = {
    programs.fish.interactiveShellInit = builtins.readFile ./worktree.fish;
  };
}
