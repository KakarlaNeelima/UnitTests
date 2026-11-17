[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$installDirectory = Join-Path $env:LOCALAPPDATA 'CameraMonitor'
$installedScript = Join-Path $installDirectory 'CameraMonitor.ps1'
$shortcutPath = Join-Path ([Environment]::GetFolderPath('Startup')) 'Camera Monitor.lnk'

$monitorProcesses = @(
    Get-CimInstance Win32_Process -Filter "Name = 'powershell.exe'" -ErrorAction SilentlyContinue |
        Where-Object {
            $_.ProcessId -ne $PID -and
            $_.CommandLine -and
            $_.CommandLine.IndexOf($installedScript, [System.StringComparison]::OrdinalIgnoreCase) -ge 0
        }
)

foreach ($process in $monitorProcesses) {
    Stop-Process -Id $process.ProcessId -Force -ErrorAction SilentlyContinue
}

Remove-Item -LiteralPath $shortcutPath -Force -ErrorAction SilentlyContinue
Remove-Item -LiteralPath $installedScript -Force -ErrorAction SilentlyContinue

if (Test-Path -LiteralPath $installDirectory) {
    Remove-Item -LiteralPath $installDirectory -Force -ErrorAction SilentlyContinue
}

Write-Host 'Camera Monitor uninstalled.'
