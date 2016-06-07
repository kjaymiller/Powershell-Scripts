$termed = get-aduser -Filter {Description -like "*termed*"}

function log {
param ($message)
$message | out-file -FilePath C:\users\kmiller\Desktop\users.txt -Append | Out-Null
}

foreach ($entry in $termed) {
    $membership = Get-adgroup -LDAPFilter "(member=$entry)"

    if ($membership.count -ne 0){
        $name = $entry.Name
        log $name

        foreach ($group in $membership) {
            Remove-ADGroupMember $group $entry -Verbose -Confirm:$false
            $message = "removed from " + $group.name
            log $message
            log ''
            }
          
            
        }

        }