$hostname = Read-Host "File Name?"
$csv = import-csv C:\Users\kmiller\Desktop\$hostname
foreach ($user in $csv) {
    $extension = " Ext." + $user.Extension
    $person = $user.Email.Split("@")[0]
    $manager = $user.manager_email.Split("@")[0]

    #get-aduser $person -Properties title,company
    set-aduser $person -manager $manager -Department $user.'Department Name' -Title $user.'Job Title' 
    set-Aduser $person -manager $manager -Replace @{telephonenumber=$extension}

    }