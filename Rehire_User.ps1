<#
This script will use the following user tools:
chooseDepartment - Get's the approriate user Department based on Department Matrix.csv
addGroup - Add's user to appropriate groups based on information provided
#>

#commands for each item in CSV file
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

    #find User based on First Name and Last Name
    $sama = get-aduser -filter {(surname -eq $LastName) -and (givenname -eq $firstname)}
    $sama = $sama.SamAccountName
        
    #get-Account Information
    $user.Manager = $user.Manager.Split("@")[0]
    $dept_hash = Choose_Department $user.Department -corporate $user.Corporate
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
    Enable-Mailbox $email -Database $db | Out-Null
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
    add-group -sama $sama -department $Department -company $company -office $office
    
    
    ###WORKING ON... IF ITEM DOES NOT EXIST .... BREAK DO NOT PROCESS
    $adsearch = @((get-aduser -filter {samaccountname -like $sama} -SearchBase $path))
    if ($adsearch.count -ne 0) {
        get-aduser $sama -Properties memberof,description
    }

    #creates lync account
        Enable-CSUser $sama -SipAddressType SAMAccountName -SipDomain waxie.com -RegistrarPool LyncPool1.waxie.com -DomainController HQDC2.waxie.com

        
    #Updates SP List
    $SPItem = $list.GetItemById($user.ID)
    $SPItem["Processed"] = $true
    $SPItem["Employee Username"] = $sama
    $SPItem.Update()

    $web.dispose()
    Write-Host $FullName 'created successfully' -ForegroundColor Green