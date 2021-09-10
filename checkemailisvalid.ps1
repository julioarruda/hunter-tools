
param(
    [Parameter(Mandatory=$true)]
    [string]$file,
    [Parameter(Mandatory=$true)]
    [string]$domain,
    [Parameter(Mandatory=$true)]
    [string]$apikey

)

Write-Host "============================== Checking if e-mails from $($domain) is valid in Hunter =============================="

$content= Get-Content $file

$email_regex = "(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|`"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*`")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])"

$results = ($content | Select-String $email_regex -AllMatches).Matches

foreach ($item in ($results)) { 
    if ($item.Value -like "*$($domain)*")
    {
        $emailaddress = $item.Value.Replace("'","")
        Write-Host "Email found: $($emailaddress)"
        $hunter = Invoke-RestMethod -Method Get "https://api.hunter.io/v2/email-verifier?email=$($emailaddress)&api_key=$($apikey)" 

        Write-Host "Email Status: $($hunter.data.status)"
        Write-Host "======================================================================================="

        
    }
    
 }