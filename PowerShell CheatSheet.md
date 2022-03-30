# Powershell CheatSheet

This is a collection of my powershell commands and tricks that i need to write down so i don't have to look them up myself all the time.<br>
Happy scripting 🧑‍💻

## 🔐 SecureString and PSCredential object

```powershell
$SecureString = ConvertTo-SecureString "I killed Han Solo in episode 7" -AsPlainText -Force
$Credentials = New-Object System.Management.Automation.PSCredential("Kylo Ren", $SecureString)

# Decrypt
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString)
$PasswordPlainText = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
```

## 📚Active Directory

Get-ADUser by userPrincipalName.

```powershell
Get-ADuser -Filter "userPrincipalName -eq 'kylo-ren@empire.org'"
Set-ADUser -Identity "Kylo-Ren" -Add @{extensionAttribute1 = 'Ben Solo' }
#Clear extensionAttribute
Set-ADUser -Identity "Kylo-Ren" -Clear "extensionAttribute1"
#Add to proxyAddresses
Set-ADUser -Identity "Kylo-Ren" -Add @{proxyAddresses = "smtp:ben.solo@empire.org" }

#Remove all x500 from proxyAddresses for all users
Get-ADUser -filter {proxyAddresses -like '*x500*'} -Properties proxyAddresses | ForEach-Object{

    $User = $_
    $User | Select-object -ExpandProperty proxyAddresses | ForEach-object {
        $AddressToRemove = $_
        Set-ADUser -Identity $User -Remove @{ProxyAddresses = $AddressToRemove}
    }
}
```

Get all AD Users and their email details to a CSV file, excludes x400, x500 sip and mail.onmicrosoft.com items from proxyAddresses array.

```powershell
Get-ADUser -Filter * -Properties * | ForEach-Object {

    [PSCustomObject]@{
        Enabled = $_.enabled
        Name = $_.Name
        SamAccountName = $_.SamAccountName
        UserPrincipalName = $_.UserPrincipalName
        targetaddress = $_.targetaddress
        Email = $_.mail
        Mobile = $_.mobile
        Office = $_.Office
        Department = $_.Department
        Description = $_.Description
        ProxyAddresses = ($_ | Select-Object -ExpandProperty proxyAddresses | Where-Object{$_ -notmatch "sip:" -and $_ -notmatch "x500:" -and $_ -notmatch "x400:" -and $_ -notmatch "@*.mail.onmicrosoft.com"}) -join ";"
        DistinguishedName = $_.distinguishedName
    }

}| ConvertTo-Csv -NoTypeInformation | Out-File -Encoding utf8 -FilePath "$($env:USERPROFILE)\Documents\$($env:COMPUTERNAME)_UsersExport_$(Get-Date -Format "dd_MM_yyyy_hh_mm_ss").csv"
```

"Backup" AD

```powershell
#Export
$Domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
$Users = Get-ADUser -Filter * -properties * | ConvertTo-Json
$Users = ($Users).Replace("ObjectGUID","_ObjectGUID")
$Users | Out-File -Encoding utf8 "$($env:USERPROFILE)\Desktop\$($Domain.PdcRoleOwner)_users.json"

$Groups = Get-ADGroup -Filter * -properties * | ConvertTo-Json
$Groups = ($Groups).Replace("ObjectGUID","_ObjectGUID")
$Groups | Out-File -Encoding utf8 "$($env:USERPROFILE)\Desktop\$($Domain.PdcRoleOwner)_groups.json"

$Objects = Get-ADObject -Filter * | ConvertTo-Json
$Objects = ($Objects).Replace("ObjectGUID","_ObjectGUID")
$Objects | Out-File -Encoding utf8 "$($env:USERPROFILE)\Desktop\$($Domain.PdcRoleOwner)_objects.json"

#Import
$UsersImport = Get-Content -Raw -Path Users.json | ConvertFrom-Json
```

Useful .NET Classes for ActiveDirectory<br>
https://4sysops.com/wiki/useful-net-classes-for-powershell/

```powershell
[System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest()
[System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
[System.DirectoryServices.ActiveDirectory.Domain]::GetComputerDomain()

[System.DirectoryServices.ActiveDirectory.ActiveDirectorySite]::GetComputerSite()
```

## LDAP

Search for users in remote LDAP directory.

```powershell
$Domain = New-Object System.DirectoryServices.DirectoryEntry("LDAPS://empire.base:636",'kylo-ren','DadSlayerEP7')
$Searcher = New-Object System.DirectoryServices.DirectorySearcher
$Searcher.PropertiesToLoad.Add("mail")
$Searcher.PropertiesToLoad.Add("memberOf")
$Searcher.PropertiesToLoad.Add("distinguishedName")
$Searcher.SearchRoot = $Domain
$Searcher.SizeLimit = 1000
$Searcher.Filter = "(&(objectCategory=User)(SamAccountName=*))"
($Searcher.FindAll()).GetDirectoryEntry()
```

ADSISearcher examples

```powershell
([adsisearcher]"(&(objectCategory=Computer)operatingsystem=*server*)").FindAll()
```

## ⚙️ Strings + RegEx

Remove special characters from a string.

```powershell
$String = "Ålésü´nd ØÆÅ"
[Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding("Cyrillic").GetBytes($String))
# Returns: Alesu?nd OAA

# Remove all non word characters (a-z A-Z 0-9)
"All ur base, are_belong to_us!?" -replace '[\W]', ''
# Returns: Allurbaseare_belongto_us

# Remove all non word characters (a-z A-Z 0-9)
"All ur base, are_belong to_us!?" -replace '[^a-za-z0-9]', ''
# Returns: Allurbasearebelongtous

# ASCII range - www.asciitable.com
$String -replace '[^\x30-\x39\x41-\x5a\x61-\x7a]+', ''
```

Validate data with .NET classes

```powershell
#Will throw an error
[System.Net.Mail.MailAddress]("invalidEmailAddress")
```

## 📆 Scheduled Task

Create a scheduled task.

```powershell

$TaskCredentials = New-Object System.Management.Automation.PSCredential -ArgumentList 'pusur',$SecureStringPassword
$TaskCredentialsPassword = $TaskCredentials.GetNetworkCredential().Password

$Action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-file C:\Scripts\lolcats_generator.ps1'
$Trigger =  New-ScheduledTaskTrigger -Once -At 10:00  -RepetitionInterval  (New-TimeSpan -Minutes 15)
$Task = New-ScheduledTask -Action $Action -Trigger $Trigger
$Task | Register-ScheduledTask -TaskName "Can i haz a Name" -User $TaskUser -Password $TaskCredentialsPassword
```

## PowerShell remoting

```powershell
$Sessions = @()
Get-ADComputer -filter {operatingsystem -like "*server*"} | ForEach-Object {
    If([bool](Test-WSMan -ComputerName $_.name){
        $Sessions += New-PSSession -ComputerName $_.name
    }
}

Invoke-Command  -Session $Sessions -ScriptBlock {
    #List all scheduled tasks
    schtasks.exe /FO CSV
}
```

# Random

### Azure AD Connect

```powershell
Get-ADSyncScheduler

Start-ADSyncSyncCycle -PolicyType Delta
Start-Sleep -Seconds 30
Start-ADSyncSyncCycle -PolicyType Initial
```

### Splatting

```powershell
$HashTable = @{
    Path = "test.txt"
    Destination = "test2.txt"
    WhatIf = $true
}
Copy-Item @HashTable
```

### Comments

```powershell
#Requires -Version 5.0
#Requires -PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn -Version 1.0
#Requires -Modules PSWindowsUpdate
#Requires -Modules @{ ModuleName="PSWindowsUpdate"; ModuleVersion="2.2.0" }
#Requires -RunAsAdministrator
```
