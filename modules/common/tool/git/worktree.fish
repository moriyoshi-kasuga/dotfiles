# Git worktree helper

function __ja_base_path
  git worktree list | head -1 | awk '{print $1}'
end

function __ja_worktree_path
  set -l base (__ja_base_path)
  echo "$base@$argv[1]"
end

function __ja_is_worktree
  set -l top (git rev-parse --show-toplevel)
  set -l base (__ja_base_path)
  test "$top" != "$base"
end

function __ja_require_worktree
  if not __ja_is_worktree
    echo "Error: Not in a worktree" >&2
    return 1
  end
end

function __ja_parent_branch
  set -l current (git rev-parse --abbrev-ref HEAD)
  git show-branch 2>/dev/null | grep '\*' | grep -vE "\[$current(\^|~|\])" | head -1 | awk -F'[]~^[]' '{print $2}'
end

function __ja_new
  set -l branch_name $argv[1]
  if test -z "$branch_name"
    set branch_name "wip-"(random)
  end

  if not git check-ref-format --branch "$branch_name" >/dev/null 2>&1
    echo "Error: Invalid branch name '$branch_name'" >&2
    return 1
  end

  set -l worktree_path (__ja_worktree_path "$branch_name")

  git worktree add --detach "$worktree_path" HEAD; or return 1

  cd "$worktree_path"; or return 1
  git switch --create "$branch_name"
end

function __ja_get
  set -l branch_name $argv[1]
  if test -z "$branch_name"
    echo "Usage: ja get <branch>" >&2
    return 1
  end

  set -l worktree_path (__ja_worktree_path "$branch_name")

  if not git show-ref --verify --quiet "refs/remotes/origin/$branch_name"
    echo "Error: Remote branch 'origin/$branch_name' does not exist" >&2
    return 1
  end

  git worktree add "$worktree_path" "$branch_name"; or return 1

  cd "$worktree_path"
end

function __ja_pr
  set -l pr $argv[1]
  if test -z "$pr"
    echo "Usage: ja pr <number|url>" >&2
    return 1
  end

  # gh names the local branch after the head ref, except on a fork PR whose head
  # ref is the default branch -- there it prefixes the fork owner, so the
  # worktree lands at base@<head-ref> while the branch is <owner>/<head-ref>.
  set -l branch_name (gh pr view "$pr" --json headRefName --jq .headRefName)
  or return 1

  set -l worktree_path (__ja_worktree_path "$branch_name")

  gh pr checkout "$pr" --worktree "$worktree_path"; or return 1

  cd "$worktree_path"
end

function __ja_extract
  if __ja_is_worktree
    echo "Error: Already in a worktree" >&2
    return 1
  end

  set -l branch_name (git branch --show-current)
  if test -z "$branch_name"
    echo "Error: Not on a branch (detached HEAD)" >&2
    return 1
  end

  set -l parent_branch (__ja_parent_branch)
  if test -z "$parent_branch"
    echo "Error: Could not determine parent branch" >&2
    return 1
  end

  set -l worktree_path (__ja_worktree_path "$branch_name")

  git checkout "$parent_branch"; or return 1
  git worktree add "$worktree_path" "$branch_name"; or return 1

  cd "$worktree_path"
end

function __ja_mv
  set -l new_name $argv[1]
  if test -z "$new_name"
    echo "Usage: ja mv <new-branch-name>" >&2
    return 1
  end

  if not git check-ref-format --branch "$new_name" >/dev/null 2>&1
    echo "Error: Invalid branch name '$new_name'" >&2
    return 1
  end

  __ja_require_worktree; or return 1

  set -l current_path (git rev-parse --show-toplevel)
  set -l new_path (__ja_worktree_path "$new_name")

  if test -e "$new_path"
    echo "Error: '$new_path' already exists" >&2
    return 1
  end

  if git show-ref --verify --quiet "refs/heads/$new_name"
    echo "Error: Branch '$new_name' already exists" >&2
    return 1
  end

  # git worktree move leaves .git/worktrees/<id> under the old name, so rename
  # it here. Resolve the ids first: rev-parse loses its footing after the move.
  set -l wt_dir (git rev-parse --git-common-dir)
  set wt_dir "$wt_dir/worktrees"
  set -l old_id (basename (git rev-parse --git-dir))
  set -l new_id (basename "$new_path")

  # A stale id from a pre-fix rename can squat on new_id while the branch and
  # the path are both free, so nothing below would catch it. Bail out before
  # mutating anything.
  if test "$old_id" != "$new_id"; and test -e "$wt_dir/$new_id"
    echo "Error: worktree admin dir '$new_id' is already in use" >&2
    return 1
  end

  git worktree move "$current_path" "$new_path"; or return 1
  git -C "$new_path" branch -m "$new_name"; or return 1

  # Equal ids mean the move already landed the admin dir on the right name.
  if test "$old_id" != "$new_id"
    mv "$wt_dir/$old_id" "$wt_dir/$new_id"; or return 1
    echo "gitdir: $wt_dir/$new_id" >"$new_path/.git"; or return 1
  end

  cd "$new_path"
end

function __ja_del
  set -l branch_name $argv[1]

  if test -z "$branch_name"
    __ja_require_worktree; or return 1
    set branch_name (git branch --show-current)
  end

  set -l worktree_path (__ja_worktree_path "$branch_name")
  set -l current_path (git rev-parse --show-toplevel 2>/dev/null)

  if test "$current_path" = "$worktree_path"
    cd (__ja_base_path); or return 1
  end

  git worktree remove "$worktree_path"; or return 1
end

function __ja_cd
  set -l branch_name $argv[1]
  if test -n "$branch_name"
    set -l worktree_path (__ja_worktree_path "$branch_name")
    if not test -d "$worktree_path"
      echo "Error: worktree '$worktree_path' does not exist" >&2
      return 1
    end
    cd "$worktree_path"
    return
  end

  set -l selected (git worktree list | awk '
    {
      path = $1
      if (match($0, /\[[^\]]+\]/)) {
        branch = substr($0, RSTART+1, RLENGTH-2)
      } else {
        branch = "detached HEAD (" $2 ")"
      }
      print branch "\t" path
    }
  ' | fzf --no-multi --exit-0 -d '\t' --with-nth=1 \
      --preview="git -C {2} log -15 --oneline --decorate")

  if test (count $selected) -gt 0
    set -l parts (string split \t -- $selected)
    cd $parts[2]
  end
end

function __ja_home
  cd (__ja_base_path)
end

function __ja_ls
  git worktree list $argv
end

function ja --description "Git worktree helper"
  set -l cmd $argv[1]
  set -e argv[1]

  switch "$cmd"
    case new
      __ja_new $argv
    case get
      __ja_get $argv
    case pr
      __ja_pr $argv
    case extract
      __ja_extract $argv
    case mv
      __ja_mv $argv
    case del
      __ja_del $argv
    case cd
      __ja_cd $argv
    case home
      __ja_home $argv
    case ls
      __ja_ls $argv
    case '*'
      echo "Usage: ja <command> [args]"
      echo ""
      echo "Commands:"
      echo "  new [name]    Create new worktree + branch and cd (default: wip-<random>)"
      echo "  get <branch>  Checkout remote branch as worktree"
      echo "  pr <num|url>  Checkout GitHub PR as worktree (needs gh)"
      echo "  extract       Extract current branch to worktree"
      echo "  mv <name>     Rename current worktree + branch"
      echo "  del [name]    Delete worktree (default: current)"
      echo "  cd [name]     cd to worktree by name, or select with fzf"
      echo "  home          Go back to base directory"
      echo "  ls            List worktrees"
      return 1
  end
end

function __ja_complete_worktrees --description "List worktree branch names (excluding base)"
  set -l base (__ja_base_path)
  git worktree list 2>/dev/null | awk -v base="$base" '
    {
      path = $1
      if (path == base) next
      if (match($0, /\[[^\]]+\]/)) {
        branch = substr($0, RSTART+1, RLENGTH-2)
        print branch "\t" path
      }
    }
  '
end

function __ja_complete_remote_branches --description "List remote branches on origin"
  git for-each-ref --format='%(refname:strip=3)' refs/remotes/origin 2>/dev/null | grep -v '^HEAD$'
end

complete -c ja -f -n __fish_use_subcommand -a new -d "Create new worktree + branch"
complete -c ja -f -n __fish_use_subcommand -a get -d "Checkout remote branch as worktree"
complete -c ja -f -n __fish_use_subcommand -a pr -d "Checkout GitHub PR as worktree"
complete -c ja -f -n __fish_use_subcommand -a extract -d "Extract current branch to worktree"
complete -c ja -f -n __fish_use_subcommand -a mv -d "Rename current worktree + branch"
complete -c ja -f -n __fish_use_subcommand -a del -d "Delete worktree"
complete -c ja -f -n __fish_use_subcommand -a cd -d "Select worktree with fzf"
complete -c ja -f -n __fish_use_subcommand -a home -d "Go back to base directory"
complete -c ja -f -n __fish_use_subcommand -a ls -d "List worktrees"

complete -c ja -f -n "__fish_seen_subcommand_from cd del" -a "(__ja_complete_worktrees)"
complete -c ja -f -n "__fish_seen_subcommand_from get" -a "(__ja_complete_remote_branches)"
complete -c ja -f -n "__fish_seen_subcommand_from pr" -a "(__ja_complete_prs)"
