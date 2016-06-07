$photo = read-host 'Enter the file name'
$path = "C:\users\kmiller\Pictures\" + $photo
$account = read-host 'Enter username'
$pic = [byte[]](Get-Content $path -Encoding byte)
Set-ADUser $account -replace @{thumbnailphoto=$pic}        
      