
param(
    [Parameter(Mandatory=$true)]
    [string]$domain,
    [Parameter(Mandatory=$true)]
    [string]$apikey

)

Write-Host "============================== Checking $($domain) in Hunter =============================="


$hunter = Invoke-RestMethod -Method Get "https://api.hunter.io/v2/domain-search?domain=$($domain)&api_key=$($apikey)" 


foreach ($email in $hunter.data.emails){
    Write-Host "Checkin e-mail: $($email.value)"
    Write-Host "Email status: $($email.verification.status)"

    foreach ($domains in $email.sources) {
        Write-Host "Email found in: $($domains.uri)"        
    }
    Write-Host "======================================================================================="
}
