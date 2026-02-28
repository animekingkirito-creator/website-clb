# Commit changes if this folder is a git repository
# Usage: run in repo root: .\scripts\git-commit-if-git.ps1

if(-not (Get-Command git -ErrorAction SilentlyContinue)){
  Write-Host "git not found in PATH. Install git to use this script." -ForegroundColor Yellow
  exit 1
}

$root = Get-Location
if(-not (Test-Path (Join-Path $root '.git'))){
  Write-Host "No .git folder found. Initialize a repo first (git init)." -ForegroundColor Yellow
  exit 1
}

git add -A
$msg = Read-Host "Enter commit message (or press Enter to use default)"
if([string]::IsNullOrWhiteSpace($msg)){
  $msg = "Enhance UI: fonts, theme, lazy-load, webp support, socials"
}

git commit -m "$msg"
if($LASTEXITCODE -eq 0){ Write-Host "Committed changes." -ForegroundColor Green } else { Write-Host "No changes to commit or commit failed." -ForegroundColor Yellow }