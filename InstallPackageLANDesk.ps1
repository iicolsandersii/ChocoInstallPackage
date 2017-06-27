#Description: This script can be used to install a single, or multiple applications via choco example: firefoxesr,flashplayerplugin

Param(
  [array[]]$packages
)

#chocolately path
$ChocoPath = "$env:ProgramData\chocolatey\bin\choco.exe"

#check if chocolatey is installed
$ChocoInstalled = test-Path $ChocoPath

try 
{
    #if Choco is not installed, lets install it.
    if (!$ChocoInstalled)
    {
        #message back to LANDesk Core
        &"${env:ProgramFiles(x86)}\LANDesk\LDClient\SDCLIENT.EXE" /msg="Chocolatey Installing..."

        #install choco
        iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex 

        #re-readfresh environmental variables
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

        #adds our local package source
        #&choco source add -n=server-name -s "http://server-name/chocolatey" -y
    }

        #install the applications (will upgrade existing package, otherwise will install)
    foreach ($package in $packages)
    {
        #message back to LANDesk Core
        &"${env:ProgramFiles(x86)}\LANDesk\LDClient\SDCLIENT.EXE" /msg="Installing $package..."

        &cup $package -y

        #message back to LANDesk Core
        &"${env:ProgramFiles(x86)}\LANDesk\LDClient\SDCLIENT.EXE" /msg="$package installation success!"
    }
    
    &"${env:ProgramFiles(x86)}\LANDesk\LDClient\SDCLIENT.EXE" /msg="Install Complete!"
}
catch
{
    &"${env:ProgramFiles(x86)}\LANDesk\LDClient\SDCLIENT.EXE" /msg="An error occurred: $_.Exception.message"

    #if there are any errors or issues, output to a file at the path below
    $_.Exception.message | Out-File "c:\InstallPackage.txt"
    Write-Host $_.Exception.message
}
