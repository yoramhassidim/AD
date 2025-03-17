# Count Objects in CCR

Import-Module ActiveDirectory

# Specify the domain name
$domainName = "CCR.corp.intel.com"

# Get the root of the AD domain
$domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetDomain((New-Object System.DirectoryServices.ActiveDirectory.DirectoryContext('Domain', $domainName)))
$domainDN = $domain.Name -replace "\.", ",DC=" -replace "^", "DC="

# Create an LDAP search query
$ldapSearcher = New-Object DirectoryServices.DirectorySearcher
$ldapSearcher.SearchRoot = [ADSI]("LDAP://$domainDN")
$ldapSearcher.Filter = "(objectClass=*)"
$ldapSearcher.PageSize = 1000  # Use paging for large directories

# Perform the search and count results
$results = $ldapSearcher.FindAll()

Write-Host "Total number of objects in the AD domain: " $results.Count