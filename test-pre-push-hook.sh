#!/bin/bash
# Test suite for the pre-push git hook.
# Creates isolated temp repos, runs push scenarios, and asserts outcomes.

set -euo pipefail

HOOK="$(cd "$(dirname "$0")" && pwd)/configs/git/hooks/pre-push"
PASS=0
FAIL=0

assert_push_blocked() {
  local desc="$1"
  shift
  if "$@"; then
    echo "FAIL: $desc — expected push to be blocked, but it succeeded"
    FAIL=$((FAIL + 1))
  else
    echo "PASS: $desc"
    PASS=$((PASS + 1))
  fi
}

assert_push_allowed() {
  local desc="$1"
  shift
  if "$@"; then
    echo "PASS: $desc"
    PASS=$((PASS + 1))
  else
    echo "FAIL: $desc — expected push to succeed, but it was blocked"
    FAIL=$((FAIL + 1))
  fi
}

# Sets up a bare remote and a working clone with the hook installed.
# Prints the working-tree path.
setup_repos() {
  local tmp
  tmp=$(mktemp -d)

  # Bare remote.
  git init --bare "$tmp/remote.git" -q
  # Working clone.
  git clone "$tmp/remote.git" "$tmp/work" -q

  # Configure identity so commits work in CI-like environments.
  git -C "$tmp/work" config user.email "test@example.com"
  git -C "$tmp/work" config user.name "Test"

  # Install the hook via core.hooksPath (mirrors the real setup).
  local hooks_dir
  hooks_dir="$(dirname "$HOOK")"
  git -C "$tmp/work" config core.hooksPath "$hooks_dir"

  echo "$tmp"
}

# Run the hook from within the work repo, as git would, feeding it the ref line.
simulate_push() {
  local tmp="$1"
  local local_sha remote_sha

  local_sha=$(git -C "$tmp/work" rev-parse HEAD)
  remote_sha=$(git -C "$tmp/work" rev-parse origin/main 2>/dev/null \
    || echo "0000000000000000000000000000000000000000")

  (cd "$tmp/work" && echo "refs/heads/main $local_sha refs/heads/main $remote_sha" | "$HOOK")
}

# ── Test 1: clean commit is allowed ──────────────────────────────────────────
tmp=$(setup_repos)
echo "clean content" > "$tmp/work/file.txt"
git -C "$tmp/work" add file.txt
git -C "$tmp/work" commit -m "clean commit" -q

assert_push_allowed "clean commit is allowed" simulate_push "$tmp"
rm -rf "$tmp"

# ── Test 2: commit containing the marker is blocked ──────────────────────────
tmp=$(setup_repos)
echo "DO NOT SUBMIT" > "$tmp/work/file.txt"
git -C "$tmp/work" add file.txt
git -C "$tmp/work" commit -m "oops" -q

assert_push_blocked "commit with marker is blocked" simulate_push "$tmp"
rm -rf "$tmp"

# ── Test 3: marker in comment is still blocked ────────────────────────────────
tmp=$(setup_repos)
echo "# DO NOT SUBMIT: remove before merging" > "$tmp/work/file.txt"
git -C "$tmp/work" add file.txt
git -C "$tmp/work" commit -m "marker in comment" -q

assert_push_blocked "marker in a comment is blocked" simulate_push "$tmp"
rm -rf "$tmp"

# ── Test 4: marker removed in a later commit is allowed ──────────────────────
# Simulates: added in first commit (already pushed), removed in second commit.
tmp=$(setup_repos)

# First commit — already "on remote" (we'll simulate this as the remote base).
echo "DO NOT SUBMIT" > "$tmp/work/file.txt"
git -C "$tmp/work" add file.txt
git -C "$tmp/work" commit -m "add marker" -q
first_sha=$(git -C "$tmp/work" rev-parse HEAD)

# Second commit — removes the marker.
echo "clean content" > "$tmp/work/file.txt"
git -C "$tmp/work" add file.txt
git -C "$tmp/work" commit -m "remove marker" -q
second_sha=$(git -C "$tmp/work" rev-parse HEAD)

# Pretend remote is at first_sha (marker commit was already pushed).
(cd "$tmp/work" && echo "refs/heads/main $second_sha refs/heads/main $first_sha" | "$HOOK") \
  && result=0 || result=$?

if [ "${result:-0}" -eq 0 ]; then
  echo "PASS: push after removing marker is allowed"
  PASS=$((PASS + 1))
else
  echo "FAIL: push after removing marker should be allowed but was blocked"
  FAIL=$((FAIL + 1))
fi
rm -rf "$tmp"

# ── Summary ──────────────────────────────────────────────────────────────────
echo ""
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
