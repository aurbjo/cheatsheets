# Generate ImmutableIDs from OnPrem Active Directory
```powershell
$SearchBase = "OU=Starfleet Command,DC=galaxy,DC=com"

Get-ADUser -SearchBase $SearchBase -Filter * | ForEach-Object {
    $GUID = [guid](($_).objectGuid)
    $immutableId = [System.Convert]::ToBase64String($guid.ToByteArray())

    [PSCustomObject]@{
        SamAccountName = $_.SamAccountName
        UserPrincipalName = $_.UserPrincipalName
        GUID = $GUID
        ImmutableId = $immutableId

    }
}
```
