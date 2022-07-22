@Echo off
rem Check If User Has Admin Privileges
timeout /t 1 /nobreak > NUL
openfiles > NUL 2>&1
if %errorlevel%==0 (
    echo Running..
) else (
    echo You must run me as an Administrator. Exiting..
    echo.
    echo Right-click on me and select ^'Run as Administrator^' and try again.
    echo.
    echo Press any key to exit..
    pause > NUL
    exit
)

echo.
Echo.
Echo        =========================================
Echo        !     SCRIPT MADE BY NILANGSHU MAJHI    !
ECHO.       =========================================
Echo.       !  Corrupt your Windows Update Section  ! 
Echo.       =========================================
Echo.       !         Buy me a Cup of Coffee        !
Echo.       !           6290457673@paytm            !
Echo.       =========================================
Echo.
echo.
echo Welcome to Windows 10 or 11 Update Destroyer
echo.

rem Disable Update Services and Their Helpers
sc config wuauserv start= disabled
sc failure wuauserv reset= 0 actions= ""
net stop wuauserv

sc config bits start= disabled
sc failure bits reset= 0 actions= ""
net stop bits

sc config dosvc start= disabled
sc failure dosvc reset= 0 actions= ""
net stop dosvc

rem Adding Update Prevention Registry Keys
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU /v AUOptions /d 2 /t REG_DWORD /f
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU /v AutoInstallMinorUpdates /d 0 /t REG_DWORD /f
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU /v NoAutoUpdate /d 1 /t REG_DWORD /f
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU /v NoAutoRebootWithLoggedOnUsers /d 1 /t REG_DWORD /f

rem Forcefully disable update medic service
takeown /f C:\Windows\System32\WaaSMedicSvc.dll && icacls C:\Windows\System32\WaaSMedicSvc.dll /grant *S-1-1-0:F /t /c /l /q
rename C:\Windows\System32\WaaSMedicSvc.dll WaaSMedicSvc_BAK.dll
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc" /v Start /t REG_DWORD /d 4 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc" /v FailureActions /t REG_BINARY /d 000000000000000000000000030000001400000000000000c0d4010000000000e09304000000000000000000 /f

reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 1 /f

rem Delete downloaded update files
erase /f /s /q c:\windows\softwaredistribution\*.* && rmdir /s /q c:\windows\softwaredistribution
rem Disable all update related scheduled tasks
powershell -command "Get-ScheduledTask -TaskPath '\Microsoft\Windows\UpdateOrchestrator\' | Disable-ScheduledTask; Get-ScheduledTask -TaskPath '\Microsoft\Windows\UpdateAssistant\' | Disable-ScheduledTask; Get-ScheduledTask -TaskPath '\Microsoft\Windows\WaaSMedic\' | Disable-ScheduledTask; Get-ScheduledTask -TaskPath '\Microsoft\Windows\WindowsUpdate\' | Disable-ScheduledTask"
rem Disable Update Task Schedules
SCHTASKS /Change /TN "\Microsoft\Windows\WindowsUpdate\Automatic App Update" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\WindowsUpdate\Scheduled Start" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\WindowsUpdate\sih" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\WindowsUpdate\sihboot" /DISABLE

SCHTASKS /Change /TN "\Microsoft\Windows\UpdateOrchestrator\UpdateAssistant" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\UpdateOrchestrator\UpdateAssistantCalendarRun" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\UpdateOrchestrator\UpdateAssistantWakeupRun" /DISABLE

rem Delete Some Update Files
del /s /f /q %WinDir%\SoftwareDistribution\Download\*.*

rem Delete Update Helpers
takeown /F %SYSTEMDRIVE%\Windows10Upgrade\* /R /A /D Y
echo Y| cacls %SYSTEMDRIVE%\Windows10Upgrade\*.* /T /grant administrators:F
echo Please wait, this may take a while.
rmdir /S /Q %SYSTEMDRIVE%\Windows10Upgrade\

takeown /F "%SYSTEMDRIVE%\Windows 10 install\*" /R /A /D Y
echo Y| cacls "%SYSTEMDRIVE%\Windows 10 install\*.*" /T /grant administrators:F
echo Please wait, this may take a while.
rmdir /S /Q "%SYSTEMDRIVE%\Windows 10 install\"

rem Windows.Cleaner.v2.0.bat
rem Delete Temporary Files
del /s /f /q %WinDir%\Temp\*.*
del /s /f /q %WinDir%\Prefetch\*.*
del /s /f /q %Temp%\*.*
del /s /f /q %AppData%\Temp\*.*
del /s /f /q %HomePath%\AppData\LocalLow\Temp\*.*

rem Delete Used Drivers Files (Not needed because already installed)
del /s /f /q %SYSTEMDRIVE%\AMD\*.*
del /s /f /q %SYSTEMDRIVE%\NVIDIA\*.*
del /s /f /q %SYSTEMDRIVE%\INTEL\*.*

rem Delete Temporary Folders
rd /s /q %WinDir%\Temp
rd /s /q %WinDir%\Prefetch
rd /s /q %Temp%
rd /s /q %AppData%\Temp
rd /s /q %HomePath%\AppData\LocalLow\Temp

rem Delete Used Drivers Folders (Not needed because already installed)
rd /s /q %SYSTEMDRIVE%\AMD
rd /s /q %SYSTEMDRIVE%\NVIDIA
rd /s /q %SYSTEMDRIVE%\INTEL

rem Recreate Empty Temporary Folders
md %WinDir%\Temp
md %WinDir%\Prefetch
md %Temp%
md %AppData%\Temp
md %HomePath%\AppData\LocalLow\Temp

shautdown /r /f /t 10 /c "Windows 10 Update Disabled, Restarting in 10 seconds."

echo.
echo Windows 10 Update Disabled, Restarting in 10 seconds.
echo.

pause > NUL
exit
