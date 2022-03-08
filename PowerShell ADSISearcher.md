```powershell

([adsisearcher]'(objectcategory=user)').FindAll()
([adsisearcher]"(&(objectCategory=user)samaccountname=FarragherD)").FindOne().Properties
([adsisearcher]'(samaccountname=jaapbrasser)').FindOne().Properties.memberof

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
$Domain = [adsi]'LDAP://DC=jb,DC=com'
$CreateOU = $Domain.Create('OrganizationalUnit','OU=NewOUinRootofDomain')
$CreateOU.SetInfo()

# Create Group in OU
$CurrentOU = [adsi]"LDAP://OU=NewOUinRootofDomain,DC=jb,DC=com"
$CreateGroup = $CurrentOU.Children.Add('CN=HappyUsers', 'Group')
$CreateGroup.CommitChanges()

# Update the samaccount name of the group
$CreateGroup.samaccountname = 'happyusers'
$CreateGroup.CommitChanges()

# Create user
$CreateUser = $CurrentOU.Children.Add('CN=JaapBrasser', 'User')
$CreateUser.CommitChanges()

# Delete user
$NewUser = [adsi]"LDAP://CN=JaapBrasser,OU=NewOUinRootofDomain,DC=jb,DC=com"
$NewUser.DeleteTree()

# Create user
$CreateUser = $CurrentOU.Children.Add('CN=JaapBrasser', 'User')
$CreateUser.CommitChanges()

# Update user attributes
$NewUser = [adsi]"LDAP://CN=JaapBrasser,OU=NewOUinRootofDomain,DC=jb,DC=com"
$NewUser.Put('sAMAccountName','jaapbrasser')
$NewUser.Put('givenname','Jaap')
$NewUser.Put('sn','Brasser')
$NewUser.Put('displayname','Jaap Brasser')
$NewUser.Put('description','Account created using ADSI')
$NewUser.Put('userprincipalname','JaapBrasser@jb.com')
$NewUser.SetInfo()

# Set password and enable account
$NewUser.SetPassword('Secret01')
$NewUser.psbase.InvokeSet('AccountDisabled',$false)
$NewUser.SetInfo()

# Add user to group
$NewGroup = [adsi]"LDAP://CN=HappyUsers,OU=NewOUinRootofDomain,DC=jb,DC=com"
$NewGroup.Add($NewUser.Path)

# Shortened version of adding a user to a group using ADSI
([adsi]'LDAP://CN=TestGroup,CN=Users,DC=jb,DC=com').Add($NewUser.Path)

#Ambiguous Name Resolution this can be used to query LDAP
([adsisearcher]'(anr=jaap*)').FindAll()
([adsisearcher]'(anr=jaap*)').FindAll()[1].properties

# Display the attributes of the jaapbrasser AD account
([adsisearcher]'(samaccountname=jaapbrasser)').FindAll()
([adsisearcher]'(samaccountname=jaapbrasser)').FindOne().Properties.memberof
([adsisearcher]'(samaccountname=jaapbrasser)').FindOne().Properties.memberof[0]
([adsisearcher]'(samaccountname=jaapbrasser)').FindOne().Properties.memberof[1]

# Delete the OU and all of its contents
$CurrentOU.DeleteTree()


```
