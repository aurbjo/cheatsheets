# Generate ImmutableIDs from OnPrem Active Directory
Useful when migrating to new OnPrem AD, will generate ImmutableId's for all users 
```powershell
$SearchBase = "OU=Starfleet Command,DC=galaxy,DC=com"

Get-ADUser -SearchBase $SearchBase -Filter * | ForEach-Object {
    [PSCustomObject]@{
        SamAccountName = $_.SamAccountName
        UserPrincipalName = $_.UserPrincipalName
        GUID = $_.objectGuid
        ImmutableId = [System.Convert]::ToBase64String(($_.objectGuid).ToByteArray())
    }
}

<# Set the new ID in Entra ID with this command
Get-MSolUser -UserPrincipalName <User@domain.com> | Set-MsolUser -ImmutableId <ImmutableId>
#>

```
