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
        iex ((new-object net.webclient).DownloadString("https://chocolatey.org/install.ps1"))    
    
        #adds our local package source
        &choco source add -n=chocv-sa-ap01 -s "http://chocv-sa-ap01/chocolatey"

        #re-readfresh environmental variables
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")     
    }

    #pulls all the packages already installed
    $PackagesInstalled = &choco list $packages --local-only

    foreach ($package in $packages)
    {
        # checks if the package request to be install is already installed
        if ($PackagesInstalled.Split(" ") -match $package)
        {
            #message back to LANDesk Core
            &"${env:ProgramFiles(x86)}\LANDesk\LDClient\SDCLIENT.EXE" /msg="Already installed, upgrading $package Installing..."

            #upgrades the application
            &choco upgrade $package -y

            #message back to LANDEsk Core
            &"${env:ProgramFiles(x86)}\LANDesk\LDClient\SDCLIENT.EXE" /msg="Install Complete!"
        }
        else
        {
            #message back to LANDesk Core
            &"${env:ProgramFiles(x86)}\LANDesk\LDClient\SDCLIENT.EXE" /msg="Installing $package..."

            #since the application is not install we use install instead of upgrade
            &choco install $package -y

            #message back to LANDesk Core
            &"${env:ProgramFiles(x86)}\LANDesk\LDClient\SDCLIENT.EXE" /msg="$package installation success!"
        }
    }
}
catch
{
    &"${env:ProgramFiles(x86)}\LANDesk\LDClient\SDCLIENT.EXE" /msg="An error occurred: $_.Exception.message"

    #if there are any errors or issues, output to a file at the path below
    $_.Exception.message | Out-File "c:\InstallPackage.txt"
    Write-Host $_.Exception.message
}
