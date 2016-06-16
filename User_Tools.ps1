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
            if ($mi -eq "") {
            $mi = $middleinitial
            }
            else {
                $mi = ""
                }
                if ($incr -lt 2){
                $incr += 2}
                else {$icnr += 1}
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

    if ($corporate -eq $true -and $dept.'Corporate Overide' -eq $true) {
        $dept.Corporate = $true}

    return $dept
    }

function addGroup ($sama, $department, $company, $office)
{
    $group = $company + " " + $department
    if ($company -ne $office) {
        $everyone_group = $office + " Everyone"
        Add-AdGroupMember $everyone_group $sama}

    Add-AdGroupMember $group $sama
    }

function Add-Photo {
    param( 
        [Parameter(Mandatory=$True)][string]$acccount,
        $photo) 
 
        Set-Aduser $account -replace @{thumbnailphoto=$photo}
        $user.thumbnailphoto     
          }