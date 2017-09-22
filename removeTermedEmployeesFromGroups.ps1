$termed = get-aduser -Filter {Description -like "*termed*"}

foreach ($entry in $termed) {
    $membership = Get-adgroup -LDAPFilter "(member=$entry)"

    if ($membership.count -ne 0){
        $name = $entry.Name
        log $name

        foreach ($group in $membership) {
            Remove-ADGroupMember $group $entry -Verbose -Confirm:$false
            }
          
            
        }

        }