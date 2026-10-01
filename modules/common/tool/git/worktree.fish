# Git worktree helper

function __ja_worktree_entries --description "Print '<path>\t<branch>' per worktree, base first (branch empty if detached)"
  git worktree list --porcelain 2>/dev/null | awk '
    /^worktree / { path = substr($0, 10); branch = "" }
    /^branch refs\/heads\// { branch = substr($0, 19) }
    /^$/ { if (path != "") print path "\t" branch; path = "" }
    END { if (path != "") print path "\t" branch }
  '
end

function __ja_base_path
  set -l entries (__ja_worktree_entries)
  test (count $entries) -gt 0; or return 1
  string split -f1 \t -- $entries[1]
end

function __ja_worktree_path
  set -l base (__ja_base_path)
  set -l safe_name (string replace -a '/' '-' -- $argv[1])
  echo "$base@$safe_name"
end

function __ja_find_worktree --description "Print the path of the worktree that has <branch> checked out"
  for entry in (__ja_worktree_entries)
    set -l parts (string split \t -- $entry)
    if test -n "$parts[2]"; and test "$parts[2]" = "$argv[1]"
      echo "$parts[1]"
      return
    end
  end
  return 1
end

function __ja_branch_at --description "Print the branch checked out in the worktree at <path>"
  for entry in (__ja_worktree_entries)
    set -l parts (string split \t -- $entry)
    if test "$parts[1]" = "$argv[1]"
      echo "$parts[2]"
      return
    end
  end
  return 1
end

function __ja_resolve_worktree --description "Path for <branch>: its actual worktree, else the conventional base@<name>"
  # The branch may have been renamed after the worktree was created, so the
  # conventional path is only a fallback (e.g. for detached worktrees).
  __ja_find_worktree $argv[1]; or __ja_worktree_path $argv[1]
end

function __ja_locate --description "Print '<kind>\t<value>' for <branch>: worktree <path>, local <branch>, remote <ref>, or none"
  set -l name $argv[1]
  set -l path (__ja_find_worktree "$name")
  if test -n "$path"
    printf 'worktree\t%s\n' "$path"
  else if git show-ref --verify --quiet "refs/heads/$name"
    printf 'local\t%s\n' "$name"
  else if git show-ref --verify --quiet "refs/remotes/origin/$name"
    printf 'remote\t%s\n' "origin/$name"
  else
    printf 'none\t\n'
  end
end

function __ja_check_branch_name
  if not git check-ref-format --branch "$argv[1]" >/dev/null 2>&1
    echo "Error: Invalid branch name '$argv[1]'" >&2
    return 1
  end
end

function __ja_check_free_path
  # '/' is flattened to '-', so e.g. feat/a and feat-a share a path.
  if test -e "$argv[1]"
    echo "Error: '$argv[1]' already exists" >&2
    return 1
  end
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

function __ja_is_dirty --description "Succeed if the worktree at <path> has uncommitted changes"
  set -l changes (git -C "$argv[1]" status --porcelain $argv[2..-1])
  test (count $changes) -gt 0
end

function __ja_goto --description "cd to worktree <path>, keeping the current subdirectory if it exists there"
  set -l prefix (git rev-parse --show-prefix 2>/dev/null)
  if test -n "$prefix"; and test -d "$argv[1]/$prefix"
    cd "$argv[1]/$prefix"
  else
    cd "$argv[1]"
  end
end

function __ja_default_branch --description "Best-effort guess of the repo's default branch"
  set -l ref (git symbolic-ref -q refs/remotes/origin/HEAD 2>/dev/null)
  if test -n "$ref"
    string replace 'refs/remotes/origin/' '' -- $ref
    return
  end

  for candidate in main master
    if git show-ref --verify --quiet "refs/heads/$candidate"
      echo "$candidate"
      return
    end
  end
end

function __ja_parent_branch
  # Finds the local branch whose tip is the nearest ancestor of the current
  # branch, i.e. the branch `current` was most recently forked from.
  set -l current (git branch --show-current)
  if test -z "$current"
    return 1
  end

  # Branches checked out in other worktrees are skipped: extract could not
  # check them out anyway.
  set -l candidates (git for-each-ref --merged="$current" --format='%(refname:short)%09%(worktreepath)' refs/heads/ | string replace -rf '\t$' '')
  if test (count $candidates) -eq 0
    return 1
  end

  # Every candidate is an ancestor of current, so the ones no other candidate
  # descends from are the nearest fork points.
  set -l nearest (git merge-base --independent $candidates)[1]
  for branch in (git for-each-ref --points-at="$nearest" --format='%(refname:short)' refs/heads/)
    if contains -- "$branch" $candidates
      echo "$branch"
      return
    end
  end
  return 1
end

function __ja_new
  argparse 'b/base=' -- $argv
  or return 1

  set -l branch_name $argv[1]
  if test -z "$branch_name"
    set branch_name "wip-"(random)
  end

  __ja_check_branch_name "$branch_name"; or return 1

  set -l worktree_path (__ja_worktree_path "$branch_name")
  set -l located (string split \t -- (__ja_locate "$branch_name"))

  if test "$located[1]" != none; and set -q _flag_base
    echo "Warning: Branch '$branch_name' already exists; ignoring --base" >&2
  end

  switch $located[1]
    case worktree
      cd "$located[2]"
      return
    case local
      __ja_check_free_path "$worktree_path"; or return 1
      git worktree add "$worktree_path" "$branch_name"; or return 1
      cd "$worktree_path"
      return
    case remote
      __ja_check_free_path "$worktree_path"; or return 1
      git worktree add --track -b "$branch_name" "$worktree_path" "$located[2]"; or return 1
      cd "$worktree_path"
      return
  end

  set -l base_ref HEAD
  if set -q _flag_base
    if not git rev-parse --verify --quiet "$_flag_base^{commit}" >/dev/null
      echo "Error: Invalid base ref '$_flag_base'" >&2
      return 1
    end
    set base_ref $_flag_base
  end

  __ja_check_free_path "$worktree_path"; or return 1
  git worktree add --detach "$worktree_path" "$base_ref"; or return 1

  cd "$worktree_path"; or return 1
  git switch --create "$branch_name"
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
    set parent_branch (__ja_default_branch)
    if test -z "$parent_branch"; or test "$parent_branch" = "$branch_name"
      echo "Error: Could not determine parent branch" >&2
      return 1
    end
  end

  set -l worktree_path (__ja_worktree_path "$branch_name")
  __ja_check_free_path "$worktree_path"; or return 1

  # Uncommitted changes belong to the extracted branch, so carry them over
  # instead of leaving them on the parent in base.
  set -l stashed 0
  if __ja_is_dirty .
    git stash push --include-untracked -m "ja extract $branch_name"; or return 1
    set stashed 1
  end

  if not git checkout "$parent_branch"
    test $stashed -eq 1; and git stash pop --index
    return 1
  end
  if not git worktree add "$worktree_path" "$branch_name"
    git checkout "$branch_name"
    test $stashed -eq 1; and git stash pop --index
    return 1
  end

  cd "$worktree_path"; or return 1
  if test $stashed -eq 1
    if not git stash pop --index
      echo "Warning: Could not apply carried changes; they remain in the stash" >&2
      return 1
    end
  end
end

function __ja_mv
  set -l new_name $argv[1]
  if test -z "$new_name"
    echo "Usage: ja mv <new-branch-name>" >&2
    return 1
  end

  __ja_check_branch_name "$new_name"; or return 1

  __ja_require_worktree; or return 1

  set -l current_path (git rev-parse --show-toplevel)
  set -l new_path (__ja_worktree_path "$new_name")

  __ja_check_free_path "$new_path"; or return 1

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

function __ja_land
  argparse 'd/delete' -- $argv
  or return 1

  __ja_require_worktree; or return 1

  set -l branch_name (git branch --show-current)
  if test -z "$branch_name"
    echo "Error: Not on a branch (detached HEAD)" >&2
    return 1
  end

  set -l base (__ja_base_path)
  set -l home_branch (git -C "$base" branch --show-current)
  if test -z "$home_branch"
    echo "Error: Base directory is not on a branch (detached HEAD)" >&2
    return 1
  end

  # Check before rebasing: a dirty base would fail the fast-forward and leave
  # the branch rebased but not landed.
  if __ja_is_dirty "$base" --untracked-files=no
    echo "Error: Base directory has uncommitted changes" >&2
    return 1
  end

  # On conflict, resolve with `git rebase --continue` and run this again.
  git rebase "$home_branch"; or return 1

  # home_branch is checked out in base, so advance it there rather than via
  # update-ref, which would leave base's index and working tree behind.
  git -C "$base" merge --ff-only "$branch_name"; or return 1

  if set -q _flag_delete
    __ja_del --branch
  end
end

function __ja_del
  argparse 'f/force' 'b/branch' -- $argv
  or return 1

  set -l branch_name $argv[1]
  set -l current_path (git rev-parse --show-toplevel 2>/dev/null)
  set -l worktree_path

  if test -z "$branch_name"
    __ja_require_worktree; or return 1
    set worktree_path "$current_path"
  else
    set worktree_path (__ja_resolve_worktree "$branch_name")
  end

  set -l checked_out (__ja_branch_at "$worktree_path")

  if test "$current_path" = "$worktree_path"
    cd (__ja_base_path); or return 1
  end

  if set -q _flag_force
    # A single --force only bypasses the dirty-worktree check; a locked
    # worktree needs it passed twice.
    git worktree remove --force --force "$worktree_path"; or return 1
  else
    git worktree remove "$worktree_path"; or return 1
  end

  if set -q _flag_branch; and test -n "$checked_out"
    if set -q _flag_force
      git branch -D "$checked_out"
    else
      git branch -d "$checked_out"
    end
  end
end

function __ja_cd
  set -l query $argv[1]
  if test -n "$query"
    set -l worktree_path (__ja_find_worktree "$query")
    if test -n "$worktree_path"
      __ja_goto "$worktree_path"
      return
    end
  end

  set -l fzf_opts --no-multi --exit-0 -d '\t' --with-nth=1 \
    --preview="git -C {2} log -15 --oneline --decorate"
  if test -n "$query"
    set -a fzf_opts --select-1 --query "$query"
  end

  set -l selected (__ja_worktree_entries | awk -F '\t' '
    {
      branch = ($2 == "") ? "detached HEAD (" $1 ")" : $2
      print branch "\t" $1
    }
  ' | fzf $fzf_opts)

  if test (count $selected) -eq 0
    if test -n "$query"
      echo "Error: No worktree matches '$query'" >&2
    end
    return 1
  end

  set -l parts (string split \t -- $selected)
  __ja_goto $parts[2]
end

function __ja_home
  cd (__ja_base_path)
end

function __ja_ls
  git worktree list $argv
end

function __ja_prune
  git worktree prune -v $argv
end

function __ja_squash_merged --description "Succeed if <branch>'s changes are already in <target>, e.g. via a squash merge"
  set -l branch $argv[1]
  set -l target $argv[2]

  set -l fork (git merge-base "$target" "$branch" 2>/dev/null)
  or return 1

  # Squash the branch into one commit on its fork point; git cherry marks it
  # with '-' when target already has an equivalent patch.
  set -l squashed (git commit-tree "$branch^{tree}" -p "$fork" -m _ 2>/dev/null)
  or return 1
  string match -q -- '-*' (git cherry "$target" "$squashed")
end

function __ja_clean --description "Remove worktrees whose branch is merged into the default branch or whose upstream is gone"
  argparse 'n/dry-run' 'b/branch' -- $argv
  or return 1

  set -l default_branch (__ja_default_branch)
  if test -z "$default_branch"
    echo "Error: Could not determine default branch" >&2
    return 1
  end

  # The remote-tracking ref is assumed fetched, so it is usually ahead of the
  # local default branch.
  set -l target "$default_branch"
  if git show-ref --verify --quiet "refs/remotes/origin/$default_branch"
    set target "origin/$default_branch"
  end

  set -l base (__ja_base_path)
  set -l current_path (git rev-parse --show-toplevel 2>/dev/null)
  set -l merged (git for-each-ref --merged "$target" --format='%(refname:short)' refs/heads/)
  set -l gone (git for-each-ref --format='%(refname:short) %(upstream:track)' refs/heads/ | string replace -rf ' \[gone\]$' '')

  set -l cleaned 0
  for entry in (__ja_worktree_entries)
    set -l parts (string split \t -- $entry)
    set -l path $parts[1]
    set -l branch $parts[2]

    if test "$path" = "$base"; or test -z "$branch"; or test "$branch" = "$default_branch"
      continue
    end

    set -l reason
    if contains -- "$branch" $merged
      set reason merged
    else if contains -- "$branch" $gone
      set reason "upstream gone"
    else if __ja_squash_merged "$branch" "$target"
      set reason squashed
    else
      continue
    end

    if __ja_is_dirty "$path"
      echo "Skipping: $path [$branch] ($reason, but has uncommitted changes)"
      continue
    end

    if set -q _flag_dry_run
      echo "Would remove: $path [$branch] ($reason)"
      set cleaned (math $cleaned + 1)
      continue
    end

    echo "Removing: $path [$branch] ($reason)"
    if test "$path" = "$current_path"
      cd "$base"; or return 1
      set current_path ""
    end
    git worktree remove "$path"; or continue
    if set -q _flag_branch
      # Squashed and gone branches are not merged as far as git branch -d
      # can tell, so force it: the checks above already vouch for them.
      git branch -D "$branch"
    end
    set cleaned (math $cleaned + 1)
  end

  if test "$cleaned" -eq 0
    echo "Nothing to clean"
  end
end

function __ja_usage
  echo "Usage: ja [command] [args]"
  echo ""
  echo "Commands:"
  echo "  (none)                Same as cd"
  echo "  new [name] [-b base]  cd to the worktree for a branch, creating it from a local"
  echo "                        branch, origin/<name>, or a new branch (default: wip-<random>)"
  echo "  pr <num|url>          Checkout GitHub PR as worktree (needs gh)"
  echo "  extract               Extract current branch (and its uncommitted changes) to worktree"
  echo "  mv <name>             Rename current worktree + branch"
  echo "  land [-d]             Rebase current branch onto home branch and fast-forward it"
  echo "                        (-d: then delete the worktree and branch)"
  echo "  del [name] [-f] [-b]  Delete worktree (default: current; -b: also delete branch)"
  echo "  cd [name]             cd to worktree by name, or select with fzf"
  echo "  home                  Go back to base directory"
  echo "  ls                    List worktrees"
  echo "  prune                 Remove stale worktree administrative files"
  echo "  clean [-n] [-b]       Remove worktrees whose branch is merged (incl. squash) into the"
  echo "                        default branch or whose upstream is gone (-b: also delete branches)"
end

function ja --description "Git worktree helper"
  set -l cmd $argv[1]
  set -e argv[1]

  set -l commands new pr extract mv land del cd home ls prune clean
  if test -n "$cmd"; and not contains -- "$cmd" $commands
    __ja_usage
    return 1
  end

  if not git rev-parse --git-dir >/dev/null 2>&1
    echo "Error: Not in a git repository" >&2
    return 1
  end

  switch "$cmd"
    case ''
      __ja_cd
    case new
      __ja_new $argv
    case pr
      __ja_pr $argv
    case extract
      __ja_extract $argv
    case mv
      __ja_mv $argv
    case land
      __ja_land $argv
    case del
      __ja_del $argv
    case cd
      __ja_cd $argv
    case home
      __ja_home $argv
    case ls
      __ja_ls $argv
    case prune
      __ja_prune $argv
    case clean
      __ja_clean $argv
  end
end

function __ja_complete_worktrees --description "List branches checked out in worktrees (excluding base)"
  set -l base (__ja_base_path)
  git for-each-ref --format='%(refname:short)%09%(worktreepath)%09%(contents:subject)' refs/heads 2>/dev/null | awk -F '\t' -v base="$base" '
    $2 != "" && $2 != base { print $1 "\t" $3 }
  '
end

function __ja_complete_new --description "List local branches without a worktree, then origin branches without a local one"
  git for-each-ref --format='%(refname)%09%(worktreepath)%09%(contents:subject)' refs/heads refs/remotes/origin 2>/dev/null | awk -F '\t' '
    sub(/^refs\/heads\//, "", $1) {
      local[$1] = 1
      if ($2 == "") print $1 "\t" $3
      next
    }
    sub(/^refs\/remotes\/origin\//, "", $1) && $1 != "HEAD" {
      remote[$1] = $3
    }
    END { for (name in remote) if (!(name in local)) print name "\torigin: " remote[name] }
  '
end

function __ja_complete_all_refs --description "List local and remote branches"
  git for-each-ref --format='%(refname:short)' refs/heads refs/remotes 2>/dev/null | grep -v '/HEAD$'
end

complete -c ja -f
complete -c ja -f -n __fish_use_subcommand -a new -d "Open or create worktree for a branch"
complete -c ja -f -n __fish_use_subcommand -a pr -d "Checkout GitHub PR as worktree"
complete -c ja -f -n __fish_use_subcommand -a extract -d "Extract current branch to worktree"
complete -c ja -f -n __fish_use_subcommand -a mv -d "Rename current worktree + branch"
complete -c ja -f -n __fish_use_subcommand -a land -d "Rebase onto home branch and fast-forward it"
complete -c ja -f -n __fish_use_subcommand -a del -d "Delete worktree"
complete -c ja -f -n __fish_use_subcommand -a cd -d "cd to worktree, or select with fzf"
complete -c ja -f -n __fish_use_subcommand -a home -d "Go back to base directory"
complete -c ja -f -n __fish_use_subcommand -a ls -d "List worktrees"
complete -c ja -f -n __fish_use_subcommand -a prune -d "Remove stale worktree administrative files"
complete -c ja -f -n __fish_use_subcommand -a clean -d "Remove merged worktrees"

complete -c ja -f -n "__fish_seen_subcommand_from new; and __fish_is_nth_token 2" -a "(__ja_complete_new)"
complete -c ja -f -n "__fish_seen_subcommand_from cd del; and __fish_is_nth_token 2" -a "(__ja_complete_worktrees)"
complete -c ja -f -n "__fish_seen_subcommand_from mv; and __fish_is_nth_token 2" -a "(git branch --show-current 2>/dev/null)" -d "Current branch"
complete -c ja -n "__fish_seen_subcommand_from new" -s b -l base -d "Base ref to branch from (default: HEAD)" -rfa "(__ja_complete_all_refs)"
complete -c ja -f -n "__fish_seen_subcommand_from land" -s d -l delete -d "Delete the worktree and branch after landing"
complete -c ja -f -n "__fish_seen_subcommand_from del" -s f -l force -d "Remove even with uncommitted changes"
complete -c ja -f -n "__fish_seen_subcommand_from del" -s b -l branch -d "Also delete the branch"
complete -c ja -f -n "__fish_seen_subcommand_from clean" -s n -l dry-run -d "Show what would be removed without removing"
complete -c ja -f -n "__fish_seen_subcommand_from clean" -s b -l branch -d "Also delete the branches"
