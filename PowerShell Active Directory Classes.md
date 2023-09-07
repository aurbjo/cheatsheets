Useful .NET classes when working with Actice Directory
```powershell
# List all Global Catalogs in the forest (Domain Controllers)
[System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest().GlobalCatalogs

# List the current (local) computer’s domain name
[System.DirectoryServices.ActiveDirectory.Domain]::GetComputerDomain().Name

# List the current (local) computer’s domain controllers
[System.DirectoryServices.ActiveDirectory.Domain]::GetComputerDomain().DomainControllers.Name

# List the current user’s domain name
[System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().Name

# List the current user's domain controllers
[System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().DomainControllers.Name

# Get the local computer’s site information:
[System.DirectoryServices.ActiveDirectory.ActiveDirectorySite]::GetComputerSite()
```
