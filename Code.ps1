<# SPLATTING #>

$HashTable = @{
    Path        = "test.txt"
    Destination = "test2.txt"
    WhatIf      = $true
}
Copy-Item @HashTable

<# SecureString and PSCredential object#>
$SecureString = ConvertTo-SecureString "I killed Han Solo in episode 7" -AsPlainText -Force

#Create PSCredentialObject with SecureString
$Credentials = New-Object System.Management.Automation.PSCredential("Kylo Ren", $SecureString)

#Decrypt SecureString
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString)
$PasswordPlainText = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
Write-Host $PasswordPlainText

<# Active Directory #>

# Get-ADUser by userPrincipalName
Get-ADuser -Filter "userPrincipalName -eq 'kylo-ren@empire.org'" 
#Set extensionAttribute
Set-ADUser -Identity "Kylo-Ren" -Add @{extensionAttribute1 = 'Ben Solo' }
#Clear extensionAttribute
Set-ADUser -Identity "Kylo-Ren" -Clear "extensionAttribute1"

#Add to proxyAddresses
Set-ADUser -Identity "Kylo-Ren" -Add @{proxyAddresses = "smtp:ben.solo@empire.org" }

<# LDAP #>

<# String manipulation and RegEx #>
<# https://lazywinadmin.com/2015/08/powershell-remove-special-characters.html 
   https://lazywinadmin.com/2015/05/powershell-remove-diacritics-accents.html
#>
#Remove special characters from string
$String = "Ålésü´nd ØÆÅ"
[Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding("Cyrillic").GetBytes($String))
# Returns: Alesu?nd OAA

# Remove all non word characters (a-z A-Z 0-9)
"All ur base, are_belong to_us!?" -replace '[\W]', ''
# Returns: Allurbaseare_belongto_us

# Remove all non word characters (a-z A-Z 0-9)
"All ur base, are_belong to_us!?" -replace '[^a-zA-Z0-9]', ''
# Returns: Allurbasearebelongtous

# ASCII range - www.asciitable.com
$String -replace '[^\x30-\x39\x41-\x5A\x61-\x7A]+', ''