$directory = 'C:\users\kmiller\Documents\Active Directory Updates\'
$childItems = $directory + '*.csv'
$csvs = Get-ChildItem $childItems

foreach($file in $csvs){
$csv = import-csv $file
foreach ($user in $csv) {
    if ($user.Extension -ne $null)
        {$extension = " Ext." + $user.Extension}
    
    $person = $user.Email.Split("@")[0]
    $manager = $user.manageremail.Split("@")[0]

    set-aduser $person -Department $user.'Department Name' -Title $user.'Job Title'
    set-aduser $person -manager $manager
    write-host changes for $person complete -ForegroundColor Green

    }
    }
$removeitems = $directory + "*"
Remove-Item $removeitems