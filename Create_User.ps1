<#
This script will use the following user tools:
validUsername - Get a usable username
chooseDepartment - Get's the approriate user Department based on Department Matrix.csv
addGroup - Add's user to appropriate groups based on information provided
#>

    #get-ValidUsername from Active directory
    Write-Host "Getting Username"
    $sama = ValidUsername -firstname $firstname -lastname $lastname -middleinitial $middleinitial 
    Write-Host -foregroundColor Green "Username is" $sama

    #get-Account Information
    $user.Manager = $user.Manager.Split("@")[0]
    $dept_hash = ChooseDepartment $user.Department -corporate $user.Corporate
    $department = $dept_hash.'Alt Department'
    $corporate = $dept_hash.Corporate
    $office = $user.office.Substring(4) #Removes the 'WXX_'
    
    if ($corporate -eq $true) {
        $company = "Corporate"
        }
    else {
        $company = $office
    }

#ensures the User are in the correct Exchange User database
    if ($User.Title.Substring(0,1) -in 'N','O','P','Q','R','S','T','U','V','W','X','Y','Z') {
       $db = 'Users02'
        }
    Else {
        $db = 'Users01'
    }

# creates User Account and MailBox
    Write-Host 'Creating User' $fullname 
    $email = $sama + "@waxie.com"
    New-Mailbox -UserPrincipalName $email -Database $db -Password $password -ResetPasswordOnNextLogon $true -Name $fullname -DisplayName $FullName -FirstName $firstName -LastName $lastName | Out-Null
    Set-AdUser $sama -Manager $user.manager 
    Set-Aduser $sama -Description $user."Job Title" -Title $user."Job Title" 
    Set-Aduser $sama -Company $Company -Office $office

    $path_location = $user.Office

  
#get Object Location Path
    $path = "OU=" + $Department + ",OU=" + $path_location + ",OU=WAXIE Users,DC=waxie,DC=com"
    Set-Aduser $sama -department $Department 
    Get-AdUser $sama | Move-ADObject -TargetPath $path
    Enable-ADAccount $sama


    #Adds user to Group
    addgroup -sama $sama -department $Department -company $company -office $office
    
    
    ###WORKING ON... IF ITEM DOES NOT EXIST .... BREAK DO NOT PROCESS
    get-aduser $sama -Properties memberof,description
    
#creates lync account
    Enable-CSUser $sama -SipAddressType SAMAccountName -SipDomain waxie.com -RegistrarPool LyncPool1.waxie.com -DomainController HQDC2.waxie.com

        
    #Updates SP List
    $SPItem = $list.GetItemById($user.ID)
    $SPItem["Processed"] = $true
    $SPItem["Employee Username"] = $sama
    $SPItem.Update()

    $web.dispose()
    Write-Host $FullName 'created successfully' -ForegroundColor Green