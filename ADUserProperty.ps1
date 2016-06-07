<#
Title:Fetch Property from Email Header
Created: March 15, 2016
Updated: March 15, 2016
Author: Kevin Miller (kmiller@waxie.com)
#>

Function get-aduser-property {
<#
.SYNOPSIS
Takes text (content) and returns the (property) information for each user it finds

.DESCRIPTION
Searches through email header to get accounts.Returns the parameter that you request 

.EXAMPLE
property-from-email -content="jdoe@contoso.com" -property="Enabled"

.PROPERTY content
The content that you will be parsing through

.PROPERTY property
The AD Property you want to return

REPLACE <DOMAIN> with just the domain name (no suffix)
#>
    param([Parameter(Mandatory=$True,
        HelpMessage="Enter the email header information")]
        [Alias('text')]
        [string[]]$content,

        [string]$property = 'Enabled',

        [string]$regex = $False,
        [string]$regexpattern = "\w+(?=@<DOMAIN>\.com)"
        )

    if ($regex -eq $True) {
    $content = $content | Select-String -Pattern $regexpattern -AllMatches |
    Select-Object -ExpandProperty Matches |
    Select-Object -ExpandProperty Value}

    foreach ($user in $content) {
    Try{$value = get-aduser $user -Properties $property -ErrorAction Continue | Select-Object -ExpandProperty $property}
        Catch{Write-Host -ForegroundColor Red "$user not found" 
               return} 
      
    Write-Host -ForegroundColor Green "$property for $user is $value"
    }
}
