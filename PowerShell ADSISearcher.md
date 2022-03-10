```powershell

([adsisearcher]'(objectcategory=user)').FindAll()
([adsisearcher]"(&(objectCategory=user)samaccountname=FarragherD)").FindOne().Properties
([adsisearcher]'(samaccountname=FarragherD)').FindOne().Properties.memberof

# [adsisearcher] always returns arrays, to retrieve the correct data index into the array
[DateTime]::FromFileTime(([adsisearcher]"(&(objectCategory=user)samaccountname=FarragherD)").FindOne().Properties.pwdlastset[0])

# list properties from all users
([adsisearcher]'(objectcategory=user)').FindAll() | ForEach-Object {
    $_.properties.name
    $_.properties.samaccountname
}

# Get property from single user
([adsi]'LDAP://reddc1.reddomain.local/CN=Administrator,CN=Users,DC=reddomain,DC=local').sAMAccountName

# Utilize ADSI to read information from the domain
[adsi]''
$Domain = [adsi]'DC=reddomain,DC=local'
$Domain | Select-Object -Property *
$Domain.Properties
$Domain.Properties.minPwdLength
$Domain.Properties.whenCreated
$Domain.Properties.fsMORoleOwner

# Create an OU
$Domain = [adsi]'LDAP://DC=reddomain,DC=local'
$CreateOU = $Domain.Create('OrganizationalUnit','OU=RedUsers')
$CreateOU.SetInfo()

# Create Group in OU
$CurrentOU = [adsi]"LDAP://OU=RedUsers,DC=reddomain,DC=local"
$CreateGroup = $CurrentOU.Children.Add('CN=RedPeople', 'Group')
$CreateGroup.CommitChanges()

# Update the samaccount name of the group
$CreateGroup.samaccountname = 'FarragherD'
$CreateGroup.CommitChanges()

# Create user
$CreateUser = $CurrentOU.Children.Add('CN=FarragherD', 'User')
$CreateUser.CommitChanges()

# Delete user
$NewUser = [adsi]"LDAP://CN=FarragherD,OU=RedUsers,DC=reddomain,DC=local"
$NewUser.DeleteTree()

# Create user
$CreateUser = $CurrentOU.Children.Add('CN=FarragherD', 'User')
$CreateUser.CommitChanges()

# Update user attributes
$NewUser = [adsi]"LDAP://CN=FarragherD,OU=RedUsers,DC=reddomain,DC=local"
$NewUser.Put('sAMAccountName','FarragherD')
$NewUser.Put('givenname','David')
$NewUser.Put('sn','Farragher')
$NewUser.Put('displayname','David Farragher')
$NewUser.Put('description','Leader of the pack')
$NewUser.Put('userprincipalname','Farragher@reddomain.local')
$NewUser.SetInfo()

# Set password and enable account
$NewUser.SetPassword('I AM GOD')
$NewUser.psbase.InvokeSet('AccountDisabled',$false)
$NewUser.SetInfo()

# Add user to group
$NewGroup = [adsi]"LDAP://CN=FarragherD,OU=RedUsers,DC=reddomain,DC=local"
$NewGroup.Add($NewUser.Path)

# Shortened version of adding a user to a group using ADSI
([adsi]'LDAP://CN=RedGroup,OU=RedUsers,DC=reddomain,DC=local').Add($NewUser.Path)

#Ambiguous Name Resolution this can be used to query LDAP
([adsisearcher]'(anr=farr*)').FindAll()
([adsisearcher]'(anr=farr*)').FindAll()[1].properties

# Display the attributes of the FarragherD AD account
([adsisearcher]'(samaccountname=FarragherD)').FindAll()
([adsisearcher]'(samaccountname=FarragherD)').FindOne().Properties.memberof
([adsisearcher]'(samaccountname=FarragherD)').FindOne().Properties.memberof[0]
([adsisearcher]'(samaccountname=FarragherD)').FindOne().Properties.memberof[1]

# Delete the OU and all of its contents
$CurrentOU.DeleteTree()


```
