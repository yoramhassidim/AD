# Count Objects in DCAD
 
Import-Module ActiveDirectory
 
# Specify the forest name
$forestName = "DCAD.intel.com"
 
# Get the root of the AD forest
$forest = [System.DirectoryServices.ActiveDirectory.Forest]::GetForest((New-Object System.DirectoryServices.ActiveDirectory.DirectoryContext('Forest', $forestName)))
$forestDN = $forest.Name -replace "\.", ",DC=" -replace "^", "DC="
 
# Create an LDAP search query
$ldapSearcher = New-Object DirectoryServices.DirectorySearcher
$ldapSearcher.SearchRoot = [ADSI]("LDAP://$forestDN")
$ldapSearcher.Filter = "(objectClass=*)"
$ldapSearcher.PageSize = 1000  # Use paging for large directories
 
# Perform the search and count results
$results = $ldapSearcher.FindAll()
 
Write-Host "Total number of objects in the AD forest: " $results.Count