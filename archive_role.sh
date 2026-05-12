#!/usr/bin/env bash
# archive_role.sh
# Archive a role/<name> branch as a dated tag, then delete the branch (local + remote).
#
# Usage:    ./archive_role.sh <short-name>
# Example:  ./archive_role.sh quant-firm-x
#
# Effect:
#   - Creates tag 'archive/role-<name>-<YYYY-MM-DD>' at the branch tip
#   - Pushes the tag to origin
#   - Deletes the local branch
#   - Deletes the remote branch (silently no-op if it was never pushed)
#
# Refuses to run if the branch does not exist, is currently checked out,
# or if a tag for today's date already exists for this role name.
#
# To revive an archived variant later:
#   git checkout -b role/<name> archive/role-<name>-<YYYY-MM-DD>

set -euo pipefail

if [ $# -ne 1 ]; then
    echo "Usage: $0 <short-name>" >&2
    exit 1
fi

name="$1"
branch="role/${name}"
date=$(date +%Y-%m-%d)
tag="archive/role-${name}-${date}"

# Sanity: branch exists locally
if [ -z "$(git branch --list "$branch")" ]; then
    echo "Branch '$branch' does not exist locally." >&2
    exit 1
fi

# Sanity: branch is not currently checked out
current=$(git branch --show-current)
if [ "$current" = "$branch" ]; then
    echo "You are currently on '$branch'. Checkout another branch first (e.g., 'git checkout main')." >&2
    exit 1
fi

# Sanity: tag for today doesn't already exist
if [ -n "$(git tag --list "$tag")" ]; then
    echo "Tag '$tag' already exists. Re-archiving the same role on the same day is not supported." >&2
    exit 1
fi

echo "Archiving '$branch' as '$tag'..."

# Step 1: create the tag at the branch tip
git tag "$tag" "$branch"

# Step 2: push the tag to origin (clean up local tag on failure)
if ! git push origin "$tag"; then
    git tag -d "$tag" >/dev/null
    echo "Failed to push tag '$tag' to origin. Local tag cleaned up. Branch '$branch' untouched." >&2
    exit 1
fi

# Step 3: delete the local branch
git branch -D "$branch"

# Step 4: delete the remote branch (non-fatal if never pushed)
if git push origin --delete "$branch" 2>/dev/null; then
    echo "Remote branch '$branch' deleted."
else
    echo "Note: remote branch '$branch' was not deleted (it may not have been pushed). Tag and local deletion succeeded."
fi

echo ""
echo "Done. To revive this variant later:"
echo "  git checkout -b $branch $tag"
