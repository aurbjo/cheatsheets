# Install Stuff

Install stuff with PowerShell

## RST AD Tools

```powershell
#Windows 10 version 1809+
Add-WindowsCapability -Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0 -Online

# Win Server 2008 and newer
Install-WindowsFeature -Name "RSAT-AD-PowerShell" -IncludeAllSubFeature
```