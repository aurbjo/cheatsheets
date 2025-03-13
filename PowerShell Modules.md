# Microsoft Entra PowerShell
```powershell
Install-Module -Name Microsoft.Graph.Entra -Repository PSGallery -Scope CurrentUser -AllowPrerelease -Force
Connect-Entra -TenantId 'your-tenant-id' -Scopes 'User.Read.All'

Enable-EntraAzureADAlias #enable aliasing
Get-AzureADUser -Top 1
```

# Exchange Online
```powershell
Install-Module ExchangeOnline
Connect-ExchangeOnline -DelegatedOrganization <customerdomain.onmicrosoft.com>
```

# MS Online
```powershell
Install-Module MSOnline
Connect-MsolService
# If you're using a CSP tenant
Get-MsolPartnerContract -DomainName <customerdomain.onmicrosoft.com> | Select-Object TenantID
Get-MsolUser -All -TenantId <TenantID>
```

# Azure AD
```powershell
Install-Module AzureAD
Connect-AzureAD -TenantId <TenantID>
```

# Microsoft Teams and Skype for Business
```powershell
Install-Module MicrosoftTeams
Connect-MicrosoftTeams -TenantId <TenantID>

#Will connect exisiting Teams session to Skype for Business module 
$session = New-CsOnlineSession
Import-PSSession $session
```

# SharePoint Online
```powershell
Install-Module -Name Microsoft.Online.SharePoint.PowerShell

# If running PS7 (Install-Module in PS5)

# Import-Module in PS7
Import-Module Microsoft.Online.SharePoint.PowerShell -UseWindowsPowerShell

# Connect
Connect-SPOService -Url https://<customerUrl>.sharepoint.com/
```

# Security & Compliance Center
```powershell
Connect-IPPSSession -DelegatedOrganization <CustomerDomain>
```
