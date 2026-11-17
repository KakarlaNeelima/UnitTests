[CmdletBinding()]
param(
    [ValidateRange(1, 300)]
    [int]$PollSeconds = 3,

    [switch]$Once
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.Windows.Forms

$cameraRegistryPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam'
$protectedProcessNames = @(
    'csrss',
    'dwm',
    'explorer',
    'lsass',
    'powershell',
    'pwsh',
    'services',
    'smss',
    'svchost',
    'system',
    'wininit',
    'winlogon'
)

function Get-ActiveCameraRecords {
    if (-not (Test-Path -LiteralPath $cameraRegistryPath)) {
        return @()
    }

    $records = foreach ($key in Get-ChildItem -LiteralPath $cameraRegistryPath -Recurse -ErrorAction SilentlyContinue) {
        $values = Get-ItemProperty -LiteralPath $key.PSPath -ErrorAction SilentlyContinue
        if ($null -eq $values) {
            continue
        }

        $startProperty = $values.PSObject.Properties['LastUsedTimeStart']
        $stopProperty = $values.PSObject.Properties['LastUsedTimeStop']
        $start = if ($startProperty) { $startProperty.Value } else { 0 }
        $stop = if ($stopProperty) { $stopProperty.Value } else { 0 }
        if ($start -and -not $stop) {
            $relativeName = $key.Name.Substring($cameraRegistryPath.Replace('HKCU:', 'HKEY_CURRENT_USER').Length + 1)
            [PSCustomObject]@{
                Id           = $key.Name
                RelativeName = $relativeName
                RegistryKey  = $key
            }
        }
    }

    return @($records)
}

function Resolve-CameraApplication {
    param(
        [Parameter(Mandatory)]
        [pscustomobject]$Record
    )

    $isDesktopApplication = $Record.RelativeName.StartsWith('NonPackaged\', [System.StringComparison]::OrdinalIgnoreCase)
    $candidateProcesses = @()
    $displayName = $Record.RelativeName
    $executablePath = $null

    if ($isDesktopApplication) {
        $encodedPath = $Record.RelativeName.Substring('NonPackaged\'.Length)
        $executablePath = $encodedPath.Replace('#', '\')
        $displayName = [System.IO.Path]::GetFileNameWithoutExtension($executablePath)

        $candidateProcesses = @(
            Get-CimInstance Win32_Process -ErrorAction SilentlyContinue |
                Where-Object {
                    $_.ExecutablePath -and
                    $_.ExecutablePath.Equals($executablePath, [System.StringComparison]::OrdinalIgnoreCase)
                }
        )
    }
    else {
        $packageFamilyName = $Record.RelativeName.Split('\')[0]
        $package = Get-AppxPackage -ErrorAction SilentlyContinue |
            Where-Object { $_.PackageFamilyName -eq $packageFamilyName } |
            Select-Object -First 1

        if ($package) {
            $displayName = $package.Name
            $installLocation = $package.InstallLocation.TrimEnd('\') + '\'
            $candidateProcesses = @(
                Get-CimInstance Win32_Process -ErrorAction SilentlyContinue |
                    Where-Object {
                        $_.ExecutablePath -and
                        $_.ExecutablePath.StartsWith($installLocation, [System.StringComparison]::OrdinalIgnoreCase)
                    }
            )
        }
    }

    $safeProcesses = @(
        $candidateProcesses |
            Where-Object {
                $_.ProcessId -ne $PID -and
                $protectedProcessNames -notcontains ([System.IO.Path]::GetFileNameWithoutExtension($_.Name).ToLowerInvariant())
            } |
            Sort-Object ProcessId -Unique
    )

    return [PSCustomObject]@{
        DisplayName       = $displayName
        ExecutablePath    = $executablePath
        Processes         = $safeProcesses
        IsDesktopApp      = $isDesktopApplication
    }
}

function Show-CameraPrompt {
    param(
        [Parameter(Mandatory)]
        [pscustomobject]$Application
    )

    if ($Application.Processes.Count -eq 0) {
        $message = @"
Windows reports that "$($Application.DisplayName)" is using the camera, but its running process could not be identified.

Close the app manually. If the camera remains locked, open Task Manager and end the app there.
"@
        [void][System.Windows.Forms.MessageBox]::Show(
            $message,
            'Camera Monitor',
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Warning
        )
        return
    }

    $processList = ($Application.Processes | ForEach-Object { "$($_.Name) (PID $($_.ProcessId))" }) -join [Environment]::NewLine
    $scopeWarning = if ($Application.IsDesktopApp) {
        'Windows does not identify the exact window or browser tab. Confirming will close every listed process.'
    }
    else {
        'Confirming will close the listed app processes and may discard unsaved work.'
    }

    $message = @"
Camera currently in use by:

$($Application.DisplayName)
$processList

$scopeWarning

Close these processes to release the camera?
"@

    $answer = [System.Windows.Forms.MessageBox]::Show(
        $message,
        'Camera In Use',
        [System.Windows.Forms.MessageBoxButtons]::YesNo,
        [System.Windows.Forms.MessageBoxIcon]::Question,
        [System.Windows.Forms.MessageBoxDefaultButton]::Button2
    )

    if ($answer -ne [System.Windows.Forms.DialogResult]::Yes) {
        return
    }

    $failures = @()
    foreach ($process in $Application.Processes) {
        try {
            Stop-Process -Id $process.ProcessId -Force -ErrorAction Stop
        }
        catch {
            $failures += "$($process.Name) (PID $($process.ProcessId)): $($_.Exception.Message)"
        }
    }

    if ($failures.Count -gt 0) {
        [void][System.Windows.Forms.MessageBox]::Show(
            "Some processes could not be closed:`n`n$($failures -join "`n")",
            'Camera Monitor',
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error
        )
    }
}

$alreadyReported = @{}

do {
    try {
        $activeRecords = @(Get-ActiveCameraRecords)
        $activeIds = @($activeRecords | ForEach-Object { $_.Id })

        foreach ($reportedId in @($alreadyReported.Keys)) {
            if ($reportedId -notin $activeIds) {
                $alreadyReported.Remove($reportedId)
            }
        }

        foreach ($record in $activeRecords) {
            if ($alreadyReported.ContainsKey($record.Id)) {
                continue
            }

            $alreadyReported[$record.Id] = $true
            Show-CameraPrompt -Application (Resolve-CameraApplication -Record $record)
        }
    }
    catch {
        [void][System.Windows.Forms.MessageBox]::Show(
            "Camera Monitor encountered an error:`n`n$($_.Exception.Message)",
            'Camera Monitor',
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error
        )
    }

    if (-not $Once) {
        Start-Sleep -Seconds $PollSeconds
    }
} while (-not $Once)
