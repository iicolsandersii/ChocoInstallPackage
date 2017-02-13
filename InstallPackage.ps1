# Description: This script can be used to install a single, or multiple applications via choco example: firefoxesr,flashplayerplugin
# Also checks if Chocolatey is installed, if now installs the latest Chocolatey

Param(
  [string[]]$packages
)

#chocolately install path
$ChocoPath = "$env:ProgramData\chocolatey\bin\choco.exe"

#test that chocolatey is installed
$ChocoInstalled = test-Path $ChocoPath

try 
{
    #if Choco is not installed, lets install it.
    if (!$ChocoInstalled)
    {
        #install choco
        iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex

        #re-readfresh environmental variables
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        
        #adds your local package source
        #&choco source add -n=server-name -s "http://server-name/chocolatey" -y
    }
    #Since choco is installed, lets update choco
    else
    {
        #upgrading Choco
        &choco upgrade chocolatey -y --version 0.10.3
    }

    #install the applications (will upgrade existing package, otherwise will install)
    foreach ($package in $packages)
    {
        &choco upgrade $package -y -f
    }
}
catch
{
    #if there are any errors or issues, output to a file at the path below
    $_.Exception.message | Out-File "c:\InstallPackage.txt"
    Write-Host $_.Exception.message
}
