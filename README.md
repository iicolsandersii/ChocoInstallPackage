# ChocoInstallPackage

Usage: powershell -exectutionpolicy bypass ".\ChocoInstallPackage.ps1 packagename" 

This script accespts as many chocolately package names seperated with a single space "example: flashplayer googlechrome".

It will query the computer to make sure chocolatey is installed first, and if it isn't it will automatically install version vz0.10.3.

Then it will check to see if the package is already installed, if so it will change the install command to upgrade otherwise it will install the package.
