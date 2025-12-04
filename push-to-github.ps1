<#
push-to-github.ps1
Usage:
  # Option A (recommended): set the environment variable in your local session and run locally
  # $env:GITHUB_TOKEN = '<your-token-here>'
  # .\push-to-github.ps1 -Username your-username -Repo your-repo

  # Option B: script will prompt for token if not set
  .\push-to-github.ps1 -Username your-username -Repo your-repo

What it does:
  - Uses the Git executable at C:\Program Files\Git\cmd\git.exe if available.
  - Adds an authenticated remote using the token from $env:GITHUB_TOKEN (not stored by the script).
  - Pushes the local 'main' branch to origin and then removes the token from the remote URL.

Security note:
  - Avoid pasting tokens into public chat. Prefer to run this script locally with $env:GITHUB_TOKEN set.
  - If you give me a token in chat, I can use it to push for you but it will be visible here. Revoke the token after use.
#>
param(
    [Parameter(Mandatory=$true)][string]$Username,
    [Parameter(Mandatory=$true)][string]$Repo
)

$gitPath = 'C:\Program Files\Git\cmd\git.exe'
if (-not (Test-Path $gitPath)) {
    Write-Error "git.exe not found at $gitPath. Make sure Git is installed and adjust the script if needed."
    exit 1
}

$token = $env:GITHUB_TOKEN
if (-not $token) {
    $token = Read-Host -AsSecureString "Enter a GitHub Personal Access Token (will not be shown)" | ConvertFrom-SecureString
    Write-Host "Token read (obscured)."
    Write-Host "Tip: set environment variable GITHUB_TOKEN to avoid prompting."
    # Convert back for use (PowerShell limitation; if you run locally prefer env var)
    try {
        $token = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR((Read-Host -AsSecureString "Confirm token (enter again to convert for push)") ))
    } catch {
        Write-Host "Could not convert secure input; aborting."
        exit 1
    }
}

$remoteUrl = "https://$($Username):$($token)@github.com/$($Username)/$($Repo).git"

Write-Host "Using remote URL: https://$Username:***@github.com/$Username/$Repo.git"

# Add remote (overwrite if exists)
& $gitPath remote remove origin 2>$null
& $gitPath remote add origin $remoteUrl

# Push
Write-Host "Pushing 'main' to origin..."
$push = & $gitPath push -u origin main 2>&1
Write-Host $push

# Remove token from remote URL by resetting to non-authenticated HTTPS
$cleanUrl = "https://github.com/$($Username)/$($Repo).git"
& $gitPath remote set-url origin $cleanUrl

Write-Host "Done. Remote URL reset to $cleanUrl"
Write-Host "IMPORTANT: If you provided a token, revoke it after use or unset the GITHUB_TOKEN environment variable."