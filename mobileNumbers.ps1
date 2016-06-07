$file = Read-Host 'Enter the path of the csv file'
$reps = import-csv $file
foreach ($rep in $reps) {
$user = get-aduser $rep.name -Properties mobile
$mobile = $rep.mobile
$has_mobile = $user.mobile
$name = $user.name

if ($has_mobile -eq $null) {
    write-host "Setting $name mobile number to $mobile$"
    Set-ADUser $user -mobile $mobile >> C:\users\kmiller\Desktop\numbersadded.txt
 }
}
