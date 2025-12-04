# setup-repo.ps1
# Checks for Git, attempts to install via winget if missing, and initializes the repo.
# Run this in PowerShell as administrator if you want the script to install Git via winget.

Write-Host "Checking for git..."
$git = Get-Command git -ErrorAction SilentlyContinue
if (-not $git) {
    Write-Host "Git not found in PATH."
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        Write-Host "winget is available. Attempting to install Git (requires admin)."
        Write-Host "If PowerShell isn't elevated, the install may fail — re-run as Administrator."
        $answer = Read-Host "Install Git now using winget? (y/n)"
        if ($answer -eq 'y') {
            winget install --id Git.Git -e --source winget --accept-package-agreements --accept-source-agreements
            Write-Host "If the installer completed, re-open PowerShell to pick up updated PATH, then re-run this script."
            exit
        } else {
            Write-Host "Aborting install. Please install Git from https://git-scm.com/download/win then re-run this script."
            exit
        }
    } else {
        Write-Host "winget not found. Please install Git manually from https://git-scm.com/download/win and re-run this script."
        exit
    }
}

# If we reach here, git exists
Write-Host "Git found: $(git --version)"

if (-not (Test-Path .git)) {
    git init
    git add .
    git commit -m "Initial commit + GitHub Pages workflow"
    git branch -M main
    Write-Host "Local repository initialized and committed."
    Write-Host "Next: add a remote and push to GitHub with the following commands (replace placeholders):"
    Write-Host "git remote add origin https://github.com/<your-username>/<your-repo>.git"
    Write-Host "git push -u origin main"
} else {
    Write-Host "Repository already initialized locally. Run 'git status' to inspect."
}
