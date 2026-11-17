CAMERA MONITOR FOR WINDOWS
==========================

What it does
------------
CameraMonitor.ps1 checks Windows camera-privacy activity every three seconds.
When an app starts using the camera, it shows the app and process IDs. It only
closes processes after you click Yes.

Install and run automatically
-----------------------------
1. Right-click Install-CameraMonitor.ps1 and choose "Run with PowerShell".
2. If Windows blocks the script, open PowerShell in this folder and run:

   powershell -NoProfile -ExecutionPolicy Bypass -File .\Install-CameraMonitor.ps1

The installer copies the monitor to:

   %LOCALAPPDATA%\CameraMonitor

It also creates a shortcut in your Windows Startup folder, so the monitor runs
silently each time you sign in.

Run once for testing
--------------------
   powershell -NoProfile -ExecutionPolicy Bypass -File .\CameraMonitor.ps1 -Once

Uninstall
---------
   powershell -NoProfile -ExecutionPolicy Bypass -File .\Uninstall-CameraMonitor.ps1

Important limitations
---------------------
Windows identifies the executable or Store package using the camera, but it
does not identify the exact browser tab. For browsers, confirming may close all
listed browser processes and can discard unsaved work.

The monitor uses Windows' camera privacy records. A driver-level lock may not
appear there; in that case restart the app, disable/re-enable the camera in
Device Manager, or restart Windows.
