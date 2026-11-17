[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$sourceScript = Join-Path $PSScriptRoot 'CameraMonitor.ps1'
if (-not (Test-Path -LiteralPath $sourceScript)) {
    throw "CameraMonitor.ps1 was not found next to this installer."
}

$installDirectory = Join-Path $env:LOCALAPPDATA 'CameraMonitor'
$installedScript = Join-Path $installDirectory 'CameraMonitor.ps1'
$startupDirectory = [Environment]::GetFolderPath('Startup')
$shortcutPath = Join-Path $startupDirectory 'Camera Monitor.lnk'

New-Item -ItemType Directory -Path $installDirectory -Force | Out-Null
Copy-Item -LiteralPath $sourceScript -Destination $installedScript -Force

$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = (Get-Command powershell.exe).Source
$shortcut.Arguments = "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$installedScript`""
$shortcut.WorkingDirectory = $installDirectory
$shortcut.Description = 'Reports applications using the camera and offers to close them.'
$shortcut.Save()

Start-Process -FilePath (Get-Command powershell.exe).Source -ArgumentList @(
    '-NoProfile',
    '-WindowStyle', 'Hidden',
    '-ExecutionPolicy', 'Bypass',
    '-File', "`"$installedScript`""
)

Write-Host "Camera Monitor installed and started."
Write-Host "It will start automatically when you sign in."
Write-Host "Shortcut: $shortcutPath"
