# ChocoInstallPackage

Usage: powershell -exectutionpolicy bypass ".\ChocoInstallPackage.ps1 packagename" 

This script accepts as many Chocolately package names seperated with a comma "example: flashplayer,googlechrome".

It will query the computer to make sure Chocolatey is installed first, and if it isn't it will automatically install version v0.10.3.

Then it will check to see if the package is already installed, if so it will change the install command to upgrade otherwise it will install the package.

Update: 2-13-17

Added a new .ps1 that will send messages back to the LANDesk console.
