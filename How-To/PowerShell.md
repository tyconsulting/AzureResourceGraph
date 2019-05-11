# Sample PowerShell Commands

## Pre-requisite
Install Az PowerShell modules
~~~PowerShell
Install-Module Az -Repository PSGallery -Force
~~~

## Code Sample
~~~PowerShell
#Sign-in
Connect-AzAccount

#install Az.Graph module if necessary
install-module az.resourcegraph -force

#Define Resource graph search query
$Query = "where type =~ 'microsoft.storage/storageAccounts' and aliases['Microsoft.Storage/storageAccounts/networkAcls.defaultAction'] == 'Allow'" 

#Invoke search
Search-AzGraph -Query $Query | Format-Table kind, Location, ManagedBy, Name, ResourceGroup, SubscriptionId, TenantId
~~~