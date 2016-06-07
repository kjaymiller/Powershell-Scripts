$Users  = Get-aduser -SearchBase "OU=WAXIE Users, DC=WAXIE, DC=com" -Properties thumbnailphoto  -filter {(thumbnailphoto -notlike "*") -and (description -notlike '*termed*')} | Select Name, UserprincipalName

$Users | Out-File C:\Users\kmiller\Desktop\nophoto.txt