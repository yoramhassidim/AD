# Count Objects in GAR

Import-Module ActiveDirectory

# Specify the domain name
$domainName = "GAR.corp.intel.com"

# Get the root of the AD domain
$domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetDomain((New-Object System.DirectoryServices.ActiveDirectory.DirectoryContext('Domain', $domainName)))
$domainDN = $domain.Name -replace "\.", ",DC=" -replace "^", "DC="

# Create an LDAP search query
$ldapSearcher = New-Object DirectoryServices.DirectorySearcher
$ldapSearcher.SearchRoot = [ADSI]("LDAP://$domainDN")
$ldapSearcher.Filter = "(objectClass=*)"
$ldapSearcher.PageSize = 1000  # Use paging for large directories

# Initialize a timer
$timer = [System.Diagnostics.Stopwatch]::StartNew()

# Perform the search and count results
$results = @()
$searchResults = $ldapSearcher.FindAll()

foreach ($result in $searchResults) {
    $results += $result

    # Check if a minute has passed
    if ($timer.Elapsed.TotalMinutes -ge 1) {
        # Get the current timestamp
        $currentTimestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        
        # Output the count and timestamp
        Write-Host "[$currentTimestamp] Objects processed so far: $($results.Count)"
        
        $timer.Restart()  # Reset the timer
    }
}

# Final count
Write-Host "Total number of objects in the AD domain: " $results.Count