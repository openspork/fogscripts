powershell %HOMEDRIVE%\Drivers\installcerts.ps1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\UnattendSettings\PnPUnattend\DriverPaths\1" /v "Path" /t REG_SZ /d "C:\Drivers" 
pnpunattend auditsystem /L > %TEMP%\PnPUnattendLog.txt
