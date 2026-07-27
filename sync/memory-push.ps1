# Push new knowledge from the memory base to its git remote (Windows).
# Point the Claude Code SessionEnd hook at this file; safe to run manually.
# Usage: memory-push.ps1 [-MemoryDir "D:\my-vault"]
param([string]$MemoryDir = "$env:USERPROFILE\claude-memory")

Set-Location $MemoryDir
git add -A .

# Secret gate: unstage any file whose staged diff introduces key-shaped content.
$pattern = 'sk-[A-Za-z0-9_-]{20,}|ghp_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{20,}|AKIA[0-9A-Z]{16}|xox[baprs]-[A-Za-z0-9-]{10,}|eyJhbGciOi[A-Za-z0-9_-]{20,}|-----BEGIN [A-Z ]*PRIVATE KEY|AIza[0-9A-Za-z_-]{30,}'
foreach ($f in (git diff --cached --name-only)) {
  $diff = (git diff --cached -- $f) -join "`n"
  if ($diff -match $pattern) {
    git reset -q HEAD -- $f
    Write-Warning "memory-push: secret-like content in '$f' - excluded from sync, replace it with <<REDACTED>> first"
  }
}

git diff --cached --quiet
if ($LASTEXITCODE -eq 1) {
  git commit -q -m "memory: auto"
  git pull -q --rebase --autostash
  git push -q
}
