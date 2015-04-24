$SourceGroup = Read-host "Source Group"
$Destinationgroup = Read-Host "Destination Group" 
Add-ADGroupMember $Destinationgroup -Members (Get-AdGroupMember $SourceGroup)