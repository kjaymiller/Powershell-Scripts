#import Required Modules
Import-Module Lync #Add Lync Module
Get-PSSnapin -Registered | Add-PSSnapin #Add SharePoint Module
Add-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue #Add Exchange Module

$csv_path = 'C:\scripts\temp_newuser.csv'
$sama = ''
if (@(Test-Path $csv_path) -eq $true) {rm -force $csv_path}

#loads User_tools
. C:\scripts\User_Tools.ps1

#Get Sharepoint List Information
$web = get-spweb http://sharepoint.waxie.com/departments/hr/locations/w99
$list = $web.lists['New Employee Information']
$items = $list.Items
$itemlist = $items | Select -Property Title,
    @{Label="Content";Expression={$_["Content Type"]}},
    @{Label="Corporate";Expression={$_["Corporate Employee"]}},
    @{Label="Manager";Expression={$_["Manager e-mail"]}},
    @{Label="FirstName";Expression={$_["First Name"]}},
    @{Label="MiddleInitial";Expression={$_["Middle Initial"]}}, 
    @{Label="LastName";Expression={$_["Last Name"]}},
    @{Label="Department";Expression={$_["Department"]}},
    @{Label="Job Title";Expression={$_["Job Title"]}},
    @{label="Office";Expression={$_["Warehouse Location"]}},
    @{Label="Processed";Expression={$_["Processed"]}}, 
    @{Label="ID";Expression={$_["ID"]}}, 
    @{Label="Effective Date";Expression={$_["Effective Date"]}}, 
    @{Label="Rehire";Expression={$_["Rehire"]}} | Where-Object {$_.Processed -eq $False}


#Export the List Info to CSV
$itemlist | Export-Csv $csv_path

#Import the CSV File
$newuser = Import-Csv $csv_path
$password = ConvertTo-SecureString "Welcome1" -AsPlainText -Force

#commands for each item in CSV file
foreach ($user in $newuser) {

    #get base information about each user
    $firstName = (Get-Culture).TextInfo.ToTitleCase($user.FirstName.Trim())
    $lastName = (Get-Culture).TextInfo.ToTitleCase($user.LastName.Trim())
    $fullname = $firstName + " " + $lastName 
    $middleinitial = $user.MiddleInitial.ToString().Tolower()
    
    #convert middle initial if none is present and sound alarm
    if ($middleinitial -eq 'na') {
    Write-Host -foregroundColor Yellow 'Warning - No Middle Name Detected'
    $middleinitial = ''
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