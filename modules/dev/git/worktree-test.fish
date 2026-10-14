# Runs `ja` against throwaway repositories. Usage: fish worktree-test.fish <worktree.fish>
# Each repository is cloned from a local bare origin, so origin/HEAD points at main.
# `pr` (gh) and fuzzy `cd` (fzf) need network or a tty and are not covered.

source $argv[1]

set -g failures 0

function fail
  echo "FAIL: $argv" >&2
  set failures (math $failures + 1)
end

function commit_file --argument-names name
  echo $name >$name
  git add $name
  git commit -qm $name
end

function has_branch --argument-names name
  git show-ref --verify --quiet refs/heads/$name
end

# cd into a fresh clone at $root/<name>/repo, with main pushed to its origin.
function new_repo --argument-names name
  set -g repo $root/$name/repo
  mkdir -p $root/$name
  git init -q -b main $root/$name/seed
  git -C $root/$name/seed commit -q --allow-empty -m init
  git clone -q --bare $root/$name/seed $root/$name/origin.git
  git clone -q $root/$name/origin.git $repo
  cd $repo
end

# Keep the user's git config (signing, hooks, ...) out of the throwaway repositories.
set -gx GIT_CONFIG_GLOBAL /dev/null
set -gx GIT_CONFIG_NOSYSTEM 1
set -gx GIT_AUTHOR_NAME test
set -gx GIT_AUTHOR_EMAIL test@example.com
set -gx GIT_COMMITTER_NAME test
set -gx GIT_COMMITTER_EMAIL test@example.com
cd (mktemp -d)
set -g root (pwd -P)

# Outside a repository.
ja ls 2>/dev/null; and fail "ja outside a repository succeeded"

# new: a fresh branch, then the same branch again from base.
new_repo new
ja new feat/a
test (pwd) = $repo@feat-a; or fail "new: not in $repo@feat-a"
test (git branch --show-current) = feat/a; or fail "new: not on feat/a"
ja home
ja new feat/a
test (pwd) = $repo@feat-a; or fail "new: existing worktree not reused"

# new: a local branch without a worktree, a branch only on origin, and --base.
ja home
git branch local-only
ja new local-only
test (git branch --show-current) = local-only; or fail "new: local branch not checked out"
ja home
git push -q origin main:remote-only
git fetch -q
ja new remote-only
test (git rev-parse --abbrev-ref '@{upstream}') = origin/remote-only; or fail "new: origin branch not tracked"
ja home
commit_file second
ja new from-base --base HEAD~1
test (git rev-parse HEAD) = (git rev-parse main~1); or fail "new --base: wrong start point"
ja home
ja new 'bad..name' 2>/dev/null; and fail "new: invalid branch name accepted"
test -e $repo@bad..name; and fail "new: worktree created for an invalid name"

# mv: the path, the branch and git's admin dir all follow the new name.
new_repo mv
ja new feat/a
commit_file a
ja mv feat/b
test (pwd) = $repo@feat-b; or fail "mv: not in $repo@feat-b"
test (git branch --show-current) = feat/b; or fail "mv: branch not renamed"
has_branch feat/a; and fail "mv: old branch left behind"
test -e $repo@feat-a; and fail "mv: old path left behind"
string match -q '*/worktrees/repo@feat-b' (git rev-parse --git-dir); or fail "mv: admin dir not renamed"
git worktree prune
contains -- "worktree $repo@feat-b" (git worktree list --porcelain); or fail "mv: worktree lost after prune"
ja home
git branch taken
ja new feat/c
ja mv taken 2>/dev/null; and fail "mv: renamed onto an existing branch"
test (git branch --show-current) = feat/c; or fail "mv: branch changed after a refused rename"

# extract: the branch moves to a worktree with its uncommitted changes, base returns to the parent.
new_repo extract
git switch -q -c topic
commit_file topic
echo changed >topic
echo new >untracked
ja extract
test (pwd) = $repo@topic; or fail "extract: not in $repo@topic"
test (cat topic) = changed; or fail "extract: modification not carried"
test -e untracked; or fail "extract: untracked file not carried"
test (git -C $repo branch --show-current) = main; or fail "extract: base not back on main"
test -z "$(git -C $repo status --porcelain)"; or fail "extract: base left dirty"
ja extract 2>/dev/null; and fail "extract: ran inside a worktree"

# land: rebase onto the base's branch and fast-forward it; refuse when base is dirty.
new_repo land
ja new feat
commit_file feat
ja home
commit_file on-main
echo dirty >on-main
cd $repo@feat
set -l before (git -C $repo rev-parse main)
ja land 2>/dev/null; and fail "land: succeeded with a dirty base"
test (git -C $repo rev-parse main) = $before; or fail "land: moved main despite a dirty base"
git -C $repo restore on-main
ja land -d
test (pwd) = $repo; or fail "land -d: not back in base"
test -e $repo/feat; or fail "land: main does not contain the branch"
test (git rev-parse main~1) = $before; or fail "land: history is not linear on top of main"
test -e $repo@feat; and fail "land -d: worktree left behind"
has_branch feat; and fail "land -d: branch left behind"

# del: by name from base, and the current worktree.
new_repo del
ja new by-name
ja home
ja del by-name --branch
test -e $repo@by-name; and fail "del: worktree left behind"
has_branch by-name; and fail "del --branch: branch left behind"
ja new current
ja del
test (pwd) = $repo; or fail "del: not back in base"
test -e $repo@current; and fail "del: current worktree left behind"
has_branch current; or fail "del: deleted the branch without --branch"

# clean: merged, squash-merged and gone branches go; unmerged and dirty ones stay.
new_repo clean
for branch in merged squashed gone unmerged dirty
  ja new $branch
  commit_file $branch
  ja home
end
git merge -q --ff-only merged
git merge -q --squash squashed
git commit -qm squashed
git merge -q --no-edit dirty
git push -q origin main
cd $repo@gone
git push -q -u origin gone
git push -q origin --delete gone
ja home
echo changed >$repo@dirty/dirty

ja clean -n >/dev/null
for branch in merged squashed gone
  test -e $repo@$branch; or fail "clean -n: removed $branch"
end
ja clean --branch >/dev/null
for branch in merged squashed gone
  test -e $repo@$branch; and fail "clean: kept the $branch worktree"
  has_branch $branch; and fail "clean --branch: kept the $branch branch"
end
test -e $repo@unmerged; or fail "clean: removed an unmerged worktree"
test -e $repo@dirty; or fail "clean: removed a worktree with uncommitted changes"

if test $failures -gt 0
  echo "$failures ja check(s) failed" >&2
  exit 1
end
