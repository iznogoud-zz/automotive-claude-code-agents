# copilot/install.ps1
# Installs adapted automotive agent .md files to the VS Code user prompts folder
# so they are available as agents in GitHub Copilot Chat.
#
# Usage:
#   .\copilot\install.ps1              # install all agents
#   .\copilot\install.ps1 -DryRun      # preview without copying
#   .\copilot\install.ps1 -Uninstall   # remove installed automotive agents

[CmdletBinding()]
param(
    [switch]$DryRun,
    [switch]$Uninstall
)

$RepoRoot   = Split-Path $PSScriptRoot -Parent
$AgentsDir  = Join-Path $RepoRoot "agents"
$PromptsDir = Join-Path $env:APPDATA "Code\User\prompts"

Write-Host "Automotive Copilot Agent Installer"
Write-Host "==================================="
Write-Host "Agents source : $AgentsDir"
Write-Host "Prompts target: $PromptsDir"
Write-Host ""

$agentFiles = Get-ChildItem -Recurse -Path $AgentsDir -Filter "*.md"

if ($Uninstall) {
    $count = 0
    foreach ($file in $agentFiles) {
        $base   = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
        $target = Join-Path $PromptsDir "automotive-$base.agent.md"
        if (Test-Path $target) {
            Write-Host "  Remove: $target"
            if (-not $DryRun) { Remove-Item $target }
            $count++
        }
    }
    Write-Host ""
    Write-Host "Removed $count automotive agent(s)."
    exit 0
}

if (-not $DryRun) {
    New-Item -ItemType Directory -Path $PromptsDir -Force | Out-Null
}

$count = 0
foreach ($file in $agentFiles) {
    $base   = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
    $name   = "automotive-$base.agent.md"
    $target = Join-Path $PromptsDir $name
    if ($DryRun) {
        Write-Host "  [dry-run] Would copy: $($file.Name) -> $target"
    } else {
        Copy-Item -Path $file.FullName -Destination $target -Force
        Write-Host "  Installed: $name"
    }
    $count++
}

Write-Host ""
if ($DryRun) {
    Write-Host "$count agent(s) would be installed."
} else {
    Write-Host "$count agent(s) installed to $PromptsDir"
    Write-Host "Restart VS Code or reload the window to pick up new agents."
}
