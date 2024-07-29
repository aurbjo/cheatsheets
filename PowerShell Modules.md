# Microsoft Entra PowerShell
```powershell
Install-Module Microsoft.Graph.Entra -AllowPrerelease -Repository PSGallery -Force
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
#Unsupported 😣
```

# Security & Compliance Center
```powershell
Connect-IPPSSession -DelegatedOrganization <CustomerDomain>
```
