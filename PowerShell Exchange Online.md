# Powershell CheatSheet for Exchange Online



## ⛷️ Install Module and connect

```powershell
Install-Module ExchangeOnlineManagement
Connect-ExchangeOnline -UserPrincipalName my.admin.account@domain.com
# For CSP (Partner) accounts
Connect-ExchangeOnline -DelegatedOrganization mycompany.onmirosoft.com -UserPrincipalName my.csp.account@domain.com
# With prefix (Get-SourceMailbox, Set-SourceMailbox ...)
Connect-ExchangeOnline -DelegatedOrganization sourcecompany.onmirosoft.com -UserPrincipalName my.source.account@domain.com -Prefix Source
Connect-ExchangeOnline -DelegatedOrganization destinationcompany.onmirosoft.com -UserPrincipalName my.destination.account@domain.com -Prefix Destination
```

## Working with Microsoft 356 Groups
```powershell
Get-UnifiedGroup -Identity "All in*" | Set-UnifiedGroup -HiddenFromAddressListsEnabled $true
Get-UnifiedGroup -Identity "All in*" | Set-UnifiedGroup -HiddenFromExchangeClientsEnabled:$true
Get-UnifiedGroup -Identity "All in*" | Set-UnifiedGroup -UnifiedGroupWelcomeMessageEnabled:$false
Get-UnifiedGroup -Identity "All in*" | Set-UnifiedGroup -AutoSubscribeNewMembers

# fix for when you forgot to autosubscribe group members
Get-UnifiedGroup -Identity "All in*" | ForEach-Object {
    $Group = $_
    $Subscribers = Get-UnifiedGroupLinks -Identity $Group.Guid.Guid -LinkType Subscribers
    Get-UnifiedGroupLinks -Identity $Group.Guid.Guid -LinkType Members  | ForEach-Object {
        $Member = $_
        If($Member.Name -NotIn $Subscribers.Name) {
            Add-UnifiedGroupLinks -Identity $Group.Guid.Guid -LinkType Subscribers -Links $Member.Guid.Guid
            Write-Host "Subscribe $($Member.Name) to $($Group.Name)"
        }
    }
}

# to verify that members and subscribers are the same amount
Get-UnifiedGroup -Identity "All in*" | ForEach-Object {
    $Group = $_
    $Members = Get-UnifiedGroupLinks -Identity $Group.Guid.Guid -LinkType Members | Measure-object
    $Subscribers = Get-UnifiedGroupLinks -Identity $Group.Guid.Guid -LinkType Subscribers | Measure-object

    [PSCustomObject]@{
        Group = $Group.Name
        Members = $Members.Count
        Subscribers = $Subscribers.Count
    }
}

```

## Change Default calendar permission for all mailboxes
```powershell
$UserToAdd = "Default"
$AccessRightsToAdd = "Reviewer"

Get-Mailbox -RecipientTypeDetails UserMailbox | ForEach-Object {
    $Mailbox = $_
    $CalendarFolder = Get-MailboxFolderStatistics -Identity $Mailbox.PrimarySmtpAddress -FolderScope Calendar | Where-Object {$_.FolderType -eq "Calendar"}
    $CalendarFolderPath = "$($Mailbox.PrimarySmtpAddress):\$($CalendarFolder.Name)"
    $CalendarFolderPermissions = Get-MailboxFolderPermission -Identity $CalendarFolderPath -User $UserToAdd
     
    If($CalendarFolderPermissions.AccessRights -ne $AccessRightsToAdd){
        Set-MailboxFolderPermission -Identity $CalendarFolderPath -User $userToAdd -AccessRights $AccessRightsToAdd
        Write-Host "$AccessRightsToAdd permissions was set for $UserToAdd on $CalendarFolderPath" -ForegroundColor Yellow
         
    }else {
        Write-Host "$AccessRightsToAdd permissions are already present for $UserToAdd on $CalendarFolderPath" -ForegroundColor Green
    }
}
```
