#Exchange Online Module (v2)
```powershell
Install-Module ExchangeOnline
Connect-ExchangeOnline -DelegatedOrganization <customerdomain.onmicrosoft.com>
```

#MS Online Module
```powershell
Install-Module MSOnline
Connect-MsolService
Get-MsolPartnerContract -DomainName <customerdomain.onmicrosoft.com> | Select-Object TenantID
Get-MsolUser -All -TenantId <TenantID>
```

#Azure AD Module
```powershell
Install-Module AzureAD
Connect-AzureAD -TenantId <TenantID>
```

#Microsoft Teams and Skype for Business Module
```powershell
Install-Module MicrosoftTeams
Connect-MicrosoftTeams -TenantId <TenantID>

#Will connect exisiting Teams session to Skype for Business module 
$session = New-CsOnlineSession
Import-PSSession $session
```

#SharePoint Online Module
```powershell
#Unsupported 😣
```

#Security & Compliance Center Module
```powershell
Connect-IPPSSession -DelegatedOrganization <CustomerDomain>
```
