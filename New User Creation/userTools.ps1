#import Required Modules
Import-Module Lync #Add Lync Module
Get-PSSnapin -Registered | Add-PSSnapin #Add SharePoint Module
Add-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue #Add Exchange Module


function validUsername {
    param([Parameter(Mandatory=$True)][string]$firstname, 
        [Parameter(Mandatory=$True)][string]$lastname, 
        [string]$middleinitial = "") 
    
        #creates user account
    $mi = ""
    $incr = 0
    Do {
        if ($incr -eq 0) {
        $iter = ""
        }

        else {$iter = "$incr"}

        $userchk = $firstname[0] + $mi +$lastname + $iter
        $adsearch = @(get-aduser -filter {samaccountname -like $userchk})

        <#
        if set middle initial is empty and incrementer equals 0 (first use), 
        then $mi is equal to $middleinitial.

        #>

        if ($mi -eq "" -and $incr -eq 0){ 
            Write-Host "Setting Middle Initial to $middleinitial"
            $mi = $middleinitial
            }
            else {
            if ($incr -lt 2) {$incr += 2}
            else{$incr += 1}
            }
    }

    Until(($adsearch.count -eq 0) -or ($incr -eq 10))
    return $userchk.ToLower()
    }   

function chooseDepartment {
    param([Parameter(Mandatory=$True)][string]$department
    , $corporate = $false)
    
    $content = Import-Csv "C:\scripts\Department Matrix.csv" #This ensures that the latest group is correct
    $department_list = $content | Group-Object -AsHashTable -AsString -Property Name
    $dept = $department_list.$department
    $customgroup = $dept.'Custom Group'

    if ($corporate -eq $true -and $dept.'Corporate Overide' -eq $true) {
        $dept.Corporate = $true}

    return $dept
    }

function addGroup {

    param ($sama, 
           $department, 
           $company, 
           $office, 
           $customgroup='')

    $group = $company + " " + $department
    if ($company -ne $office) {
        $everyone_group = $office + " Everyone"
        Add-AdGroupMember $everyone_group $sama}

    Add-AdGroupMember $group $sama
    if ($customgroup -ne '') {
        Add-AdGroupMember $customgroup
        }
    }

function Add-Photo {
    param( 
        [Parameter(Mandatory=$True)][string]$acccount,
        $photo) 
        Workflow Test
        {
            InlineScript
            {
                $account = $Using:account
                Set-UserPhoto $account $photo
            }
        $user.thumbnailphoto     
          }
          }