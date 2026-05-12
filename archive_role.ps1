# archive_role.ps1
# Archive a role/<name> branch as a dated tag, then delete the branch (local + remote).
#
# Usage:    .\archive_role.ps1 <short-name>
# Example:  .\archive_role.ps1 quant-firm-x
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

param(
    [Parameter(Mandatory=$true)][string]$Name
)

$branch = "role/$Name"
$date   = (Get-Date).ToString("yyyy-MM-dd")
$tag    = "archive/role-$Name-$date"

# Sanity: branch exists locally
$exists = (git branch --list $branch | Out-String).Trim()
if (-not $exists) {
    Write-Error "Branch '$branch' does not exist locally."
    exit 1
}

# Sanity: branch is not currently checked out
$current = (git branch --show-current).Trim()
if ($current -eq $branch) {
    Write-Error "You are currently on '$branch'. Checkout another branch first (e.g., 'git checkout main')."
    exit 1
}

# Sanity: tag for today doesn't already exist
$tagExists = (git tag --list $tag | Out-String).Trim()
if ($tagExists) {
    Write-Error "Tag '$tag' already exists. Re-archiving the same role on the same day is not supported."
    exit 1
}

Write-Host "Archiving '$branch' as '$tag'..."

# Step 1: create the tag at the branch tip
git tag $tag $branch
if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to create tag '$tag'."
    exit 1
}

# Step 2: push the tag to origin (must succeed before we delete the branch)
git push origin $tag
if ($LASTEXITCODE -ne 0) {
    git tag -d $tag | Out-Null
    Write-Error "Failed to push tag '$tag' to origin. Local tag cleaned up. Branch '$branch' untouched."
    exit 1
}

# Step 3: delete the local branch
git branch -D $branch
if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to delete local branch '$branch'. Tag '$tag' was created and pushed; you may want to delete the branch manually."
    exit 1
}

# Step 4: delete the remote branch (non-fatal if it was never pushed)
git push origin --delete $branch 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Note: remote branch '$branch' was not deleted (it may not have been pushed). Tag and local deletion succeeded."
} else {
    Write-Host "Remote branch '$branch' deleted."
}

Write-Host ""
Write-Host "Done. To revive this variant later:"
Write-Host "  git checkout -b $branch $tag"

# Reset exit code from the optional remote-delete step (failure there is non-fatal)
exit 0
