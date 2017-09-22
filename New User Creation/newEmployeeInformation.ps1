#loads User_tools
.userTools.ps1

#Get Sharepoint List Information
$web = get-spweb http://sharepoint.waxie.com/departments/hr/locations/w99
$list = $web.lists['New Bees']
$items = $list.Items

$newusers = @()
$listvalues = $items | Where-Object {$_["Processed"] -eq $false} | foreach {
    $ExportItem = New-Object PSObject
    $ExportItem | Add-Member -MemberType NoteProperty -name "Preferred First Name" -Value $_["Preferred First Name"]
    $ExportItem | Add-Member -MemberType NoteProperty -name "Preferred Last Name" -Value $_["Preferred Last Name"]
    $ExportItem | Add-Member -MemberType NoteProperty -name "Job Title" -Value $_["Job Title"]
    $ExportItem | Add-Member -MemberType NoteProperty -name "Warehouse Location" -Value $_["Warehouse Location"]
    $ExportItem | Add-Member -MemberType NoteProperty -name "Middle Initial" -Value $_["Middle Initial"]
    $ExportItem | Add-Member -MemberType NoteProperty -name "No Middle Initial" -Value $_["No Middle Initial"]
    $ExportItem | Add-Member -MemberType NoteProperty -name "Manager" -Value $_["Manager e-mail"].Split("@")[0]
    $ExportItem | Add-Member -MemberType NoteProperty -name "Department" -Value $_["Department"]
    $ExportItem | Add-Member -MemberType NoteProperty -name "Corporate" -Value $_["Corporate"]
    $ExportItem | Add-Member -MemberType NoteProperty -name "Id" -Value $_.Id
    
    $newusers += $ExportItem}

#commands for each item
foreach ($user in $newusers) {

    #get base information about each user
    $firstName = (Get-Culture).TextInfo.ToTitleCase($user."Preferred First Name".Trim())
    $lastName = (Get-Culture).TextInfo.ToTitleCase($user."Preferred Last Name".Trim())
    $fullname = $firstName + " " + $lastName 
    
    #convert middle initial if none is present and sound alarm
    if ($user.'Middle Initial' -eq $null) {
        if ($user."No Middle Initial" -eq "$false") {
            Write-Host -foregroundColor Yellow 'Warning - No Middle Name Detected'            
            $middleinitial = ''
        }
        else {
            Write-Host -foregroundColor Red 'Warning - No Middle Name Set - Terminating Script'
            return
            }
   }
    else {
        $middleinitial = $user.'Middle Initial'
    }

    if ($user.Rehire -eq $True) {
        Write-Host Executing Rehire
        . C:\scripts\Rehire_User.ps1  
         
    }
    else {
        Write-Host Executing New User
        . C:\scripts\Create_User.ps1
        }
        }