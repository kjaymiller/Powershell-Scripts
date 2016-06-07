clear
$firstname = (Read-Host 'Enter the first name').toLower()
$middleinitial = (Read-Host 'Enter your middle initial').toLower()
$lastname = (Read-Host 'Enter the last name').toLower()

$attempt1 = $firstname[0] + $lastname
$attempt2 = $firstname[0] + $middleinitial[0] + $lastname
$attempt3 = $firstname + $lastname
$attempt4 = $firstname + $middleinitial[0] + $lastname

$attempts = @($attempt1, $attempt2, $attempt3, $attempt4)

foreach ($_ in $attempts) {
    $list = @((get-aduser -filter {samaccountname -like $_}))
    if ($list.count -eq 0) {
        $result = $_
        break
        }
    }
   
Write-Host 'The result is' $result