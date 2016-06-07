$computer = [ADSI]"WinNT://$env:computername,computer" 
$group = $computer.psbase.Children.find("Administrators")

function ListAdministrators
{$members = $group.psbase.invoke("Members") | %{$_.GetType().InvokeMember("Name",'GetProperty',$null,$_,$null)}
$members} 

$group.Add("WinNT://waxie.com/" + $env:USERNAME)

ListAdministrators | Out-File \\waxie.com\sysvol\waxie.com\RMUSERAdmin\$env:username.txt
