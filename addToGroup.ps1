$user = Read-Host 'enter the username of the user'
$group = Read-Host 'enter the name of the group'
Add-ADGroupMember $group $user