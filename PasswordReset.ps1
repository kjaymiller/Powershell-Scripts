$user = Read-Host 'What is the Username'
Unlock-ADAccount $user
Set-ADAccountPassword $user -Reset 
Set-ADUser $user -ChangePasswordAtLogon $true
