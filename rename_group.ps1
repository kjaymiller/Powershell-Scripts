$old_name = Read-Host 'What is the Current Group Name'
$new_name = Read-Host 'What is the New Group Name'

Write-Host "Changing " $old_name "to" $new_name
$group = Get-Adgroup -filter {Name -eq $old_name} -Searchbase "OU=Groups, DC=WAXIE, DC=COM"
rename-adobject $group $new_name

sleep 2 -Seconds
get-adgroup $new_name