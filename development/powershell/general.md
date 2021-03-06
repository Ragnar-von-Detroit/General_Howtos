# General

* PowerShell is a task automation and configuration management framework
* full access to [COM](https://en.wikipedia.org/wiki/Component_Object_Model), [WMI](https://en.wikipedia.org/wiki/Windows_Management_Instrumentation), [WS-Management](https://en.wikipedia.org/wiki/WS-Management) and [CIM](https://en.wikipedia.org/wiki/Common_Information_Model_(computing))
* has build in commands plus Cmdlets (following a Verb-Noun naming pattern)
* use the "Windows PowerShell ISE" to have a more gui friendly autocomplete
* the shebang for powershell is `#!/usr/bin/env pwsh`

# Usefull commands

| Power Shell Command | Power Shell Alias | Unix Command | Comment |
| --- | --- | --- | --- |
| Clear-Host | clear | clear | |
| Copy-Item | cp | cp | |
| Get-Children | ls | ls | |
| Get-Content | cat | cat | |
| Get-Command | gcm | type, which | |
| Get-Service | | systemctl list-units | |
| Get-Date | | |
| Get-Help | help, man | apropos, man | |
| Get-Location | pwd | pwd | |
| Get-Process | ps | ps | |
| Invoke-WebRequest | iwr | wget, curl | |
| Measure-Performance | | | Measure-Performance {#your command call here} |
| Move-Item | mv | mv | |
| Pop-Location | popd | popd | |
| Push-Location | pushd | pushd | |
| Remove-Item | rm | rm, rmdir | |
| Rename-Item | mv | mv | |
| Restart-Service | | | Restart-Service -InputObject $(Get-Service -Computer <computer name> -Name <service name>) |
| Select-String | sls | find, grep | |
| Set-Location | cd | cd | |
| Set-Variable | set | export, env, set, setenv | |
| Start-Service | | | Start-Service -InputObject $(Get-Service -Computer <computer name> -Name <service name>) |
| Stop-Service | | | Stop-Service -InputObject $(Get-Service -Computer <computer name> -Name <service name>) |
| Stop-Process | kill | kill | |
| Tee-Object | tee | tee | |
| Test-Connection | ping | ping | |
| Write-Host | | | use it if you want to output directly to the console |
| Write-Output | echo | echo | use it if you want to pipe it |

## Set execution policy

```
#Allow all
Set-ExecutionPolicy -ExecutionPolicy Unrestricted

#Set back to default
Set-ExecutionPolicy -ExecutionPolicy Default
```

# Function

## Run a script file

```
powershell -ExecutionPolicy Bypass -File my_script.ps1
```

## Execute a ps1 script from inside a ps1 script

```pwsh
#both versions are working
Invoke-Expression -Command "\\path\to\the\script.ps1"
#this too
"\\path\to\the\script.ps1" | Invoke-Expression
```

# link

## Basic example

```
#Want to know how to write a function in Powershell?
Get-Help About_Functions

#function definition
function my_function ($ParameterOne, $ParameterTwo)
{
    //body
}

#there are two ways to call it
my_function valueOne valueTwo
my_function -ParameterOne valueOne -ParameterTwo valueTwo
```

# Modules

* Only the administrator can install a module
* Online repository is available at [powershellgallery.com](https://www.powershellgallery.com/)

## How to install

```
#list installed modules
Get-Module
#list available modules including commandlets
Get-Module -ListAvailable
#list installed
Get-Module -All
#list modules having update in their name
Get-Module -Name "*update*"

#use online repository
Install-Module -Name PSScriptAnalyzer

#use local file
Import-Module path\to\the\PSScriptAnalyzer.psd1

#list functions per module
Get-Command -Module PSScriptAnalyzer
#list synopsis/help for a module function name
Get-Help -Name Start-WUScan
```

## Useful modules

* [PSScriptAnalyzer](https://www.powershellgallery.com/packages/PSScriptAnalyzer/)
* [PSWindowsUpdate](https://www.powershellgallery.com/packages/PSWindowsUpdate/)
* [PSLogging](https://www.powershellgallery.com/packages/PSLogging/)
* [Pester (BDD Test framework)](https://www.powershellgallery.com/packages/Pester/)
* [VMware.Vim](https://www.powershellgallery.com/packages/VMware.Vim/)

# Usage Examples

## Output


```
#dump function body of Start-WUScan
Get-Content Function:\Start-WUScan

#if you experience the "..." (three dots) when dumping an object (e.g. Get-Acl)
#  pipe the output through SELECT and expand the property you want to display
<your command> | SELECT -expandproperty <property name>
```

## Variable type detection

```
#prints "System.String" etc.
<variable>.GetType().FullName
```

## Strings

```
"My String".toupper()
"My String".tolower()
```

## Arrays

```
#create
$array = New-Object System.Collections.ArrayList

#add one
$array.add("foo")

#remove one by name
$array.remove("foo")
#remove by index number and amount
$array.removerange(1,1)
```

## Environment

```
#List all environment variables
# @see: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_environment_variables
# Same as "Set-Location Env:" and "Get-ChildItem" or "Get-ChildItem Env:"
Get-Item -Path Env:*


```

## Filesystem

```
#check if path is a root path or not
#does not check if path exists!
[System.IO.Path]::IsPathRooted($path)
```

```
#create temporary file name
$temporaryFilePath = [System.IO.Path]::GetTempFileName()

#create time
(Get-Item c:file.foo).creationtime
#modification time
(Get-Item c:file.foo).lastwritetime
#size
"{0:N2}" -f ((Get-Item c:file.foo).length/1mb) + " MB"
#extension
(Get-Item c:file.foo) | SELECT extension
#basedir
c:file.foo | SELECT directory
#security permissions
(Get-Item c:file.foo).getaccesscontrol.invoke() | SELECT owner -ExpandProperty access

#cat foo >> bar
Add-Content "bar" (Get-Content "foo")

#list empty files
Get-Childitem -Recurse | foreach-object {
    if(!$_.PSIsContainer -and $_.Length -eq 0) { #!$_.PSIsContainer = is not a directory
        Write-Host ("File {0} has a size of {1}" -f $_.FullName, $_.Length)
    }
}
```

## Network

```
#get ip by name
[System.Net.DNS]::GetHostAddresses("bazzline.net")

#get name by ip
[System.Net.DNS]::GetHostByAddress("127.0.0.1")

#get neighbor ip addresses
Get-NetNeighbor -AddressFamily IPv4 | WHERE {$_.state -eq "stale" -or $_.state -eq "reachable"}

#login to remote pc
Enter-PSSession -ComputerName <hostname|ip address> -Credentials <username>
#run command on remote pc
#@see: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/invoke-command?view=powershell-7
Invoke-Command -Computer <hostname|ip address> -ScriptBlock {Get-Service}
#restart remote pc
Restart-Computer -ComputerName <hostname|ip address> [-Force]
#power off remote pc
Stop-Computer -ComputerName <hostname|ip address> [-Force]
#Ping remote pc
Test-Connection -ComputerName <hostname|ip address> -Source <host name|ip address>
#rename a pc
Rename-Computer -ComputerName <hostname|ip address> -LocalCredential Domain\User -Restart
#add a pc to the domain
Add-Computer -ComputerName <hostname[,hostname[,...]]> -DomainName <domain name> -Credential Domain\User -Restart
#get services on remote pc
Get-Service -ComputerName <hostname> [-Name <servicename>] [-Status <Running|Stopped>]
#filter by name
Get-Service -ComputerName <hostname> | Where-Object {$_.name -Like 'Win*'}
#modifie a service
Set-Service -ComputerName <hostname> -Name <servicename> -Status <Running|Stopped>
#start a task
Start-Job -FilePath <path to the powershell script>
```

## Active Directory

```
#get ad user
Get-ADUser -Identity <samUserName> -Properties *

#move ad object to a different OU
Move-ADObject -Identity "CN=DC01,OU=TestServers,OU=Administration,DC=bazzline,DC=net" -TargetPath "OU=ProductionServers,OU=Administration,DC=bazzline,DC=net"

#set ad user property
Set-ADUser -Identity <samUserName> -EmailAddress "john_doe@company.com"

#list all users with the name containing 'zub'
Get-AdUser -Filter {(Name -like "*zub*")} | Select -Property Name,GivenName,SamAccountName,Surname,Enabled | Format-Table
#list all users with the name containing 'zub' or 'buz'
Get-AdUser -Filter {(Name -like "*zub*") -o (Name -lile "*buz*")} | Select -Property Name,GivenName,SamAccountName,Surname,Enabled | Format-Table

#list all pc names starting with 'nb-'
Get-ADComputer -Filter {(Name -like "nb-*")} | Select -Property Name,DNSHostName,Enabled,LastLogonDate | Format-Table

#get last login/logon timestamp
Get-ADUser $username | Get-ADObject -Properties lastLogon
```

## Users

```
#get users on a (terminal) server
Query User /server:terminalserver01
```

# Write verbose script


```
#store existing value to reset it at the end of your script
$oldVerbosePreference = $VerbosePreference
#Enables verbose
$VerbosePreference = "continue"

#bind all built in flags etc in your function

Function My-Function
{
    [cmdletbinding()]
    Param()

    Write-Verbose "Test Verbose"
}

#...
#restore old value at the end of your script
$VerbosePreference = $oldVerbosePreference
```

# Links

* [PowerShell - wikipedia.org](https://en.wikipedia.org/wiki/PowerShell) - 2020-01-27
* [PowerShll Examples - technibee.com](https://techibee.com/category/powershell) - 2020-01-29
* [Scripting blog - microsoft.com](https://devblogs.microsoft.com/scripting/feed/) - 2020-01-29
* [Powershellbrows.com](https://www.powershellbros.com/) - 2020-01-29
* [ActiveDirectory Module - microsoft.com](https://docs.microsoft.com/en-us/powershell/module/addsadministration/?view=win10-ps) - 2020-01-29
* [PowerShell Tip of the Week: Move computer objects to OU](https://www.powershellbros.com/powershell-move-computer-objects-to-ou/) - 2020-02-05
* [Use PowerShell to Write Verbose Output](https://devblogs.microsoft.com/scripting/use-powershell-to-write-verbose-output/) - 2020-07-30
