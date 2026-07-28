# Install the auto-memory skills and agents for Claude Code (Windows).
# Usage:  .\install.ps1 [-MemoryPath "D:\my-vault"]
param(
  [string]$MemoryPath = "$env:USERPROFILE\claude-memory"
)

$ErrorActionPreference = "Stop"
$src = $PSScriptRoot
$skills = "$env:USERPROFILE\.claude\skills"
$agents = "$env:USERPROFILE\.claude\agents"

New-Item -ItemType Directory -Force $skills, $agents, $MemoryPath | Out-Null

Copy-Item -Recurse -Force "$src\skills\save"   "$skills\save"
Copy-Item -Recurse -Force "$src\skills\recall" "$skills\recall"
Copy-Item -Recurse -Force "$src\skills\unsave" "$skills\unsave"
Copy-Item -Force "$src\agents\memory-saver.md"    "$agents\memory-saver.md"
Copy-Item -Force "$src\agents\memory-recaller.md" "$agents\memory-recaller.md"
Copy-Item -Force "$src\agents\memory-undoer.md"   "$agents\memory-undoer.md"

# Point every installed file at the chosen memory base.
$targets = Get-ChildItem -Recurse -File "$skills\save", "$skills\recall", "$skills\unsave" | Select-Object -ExpandProperty FullName
$targets += "$agents\memory-saver.md", "$agents\memory-recaller.md", "$agents\memory-undoer.md"
foreach ($f in $targets) {
  (Get-Content $f -Raw).Replace('~/claude-memory', $MemoryPath) | Set-Content $f -Encoding utf8 -NoNewline
}

Write-Host "Installed. Memory base: $MemoryPath"
Write-Host "Restart Claude Code, then try: /save  or  /recall"
