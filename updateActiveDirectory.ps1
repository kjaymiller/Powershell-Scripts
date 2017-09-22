$directory = write-Host "Enter the full path of the directory"
$childItems = $directory + '*.csv'
$csvs = Get-ChildItem $childItems

foreach($file in $csvs){
$csv = import-csv $file
foreach ($user in $csv) {
    $person = $user.Email.Split("@")[0]
    $manager = $user.manageremail.Split("@")[0]

    set-aduser $person -Department $user.'Department Name' -Title $user.'Job Title'
    set-aduser $person -Description $user.'Job Title'
    set-aduser $person -manager $manager
    write-host changes for $person complete -ForegroundColor Green

    }
    }
$removeitems = $directory + "*"
#Remove-Item $removeitems