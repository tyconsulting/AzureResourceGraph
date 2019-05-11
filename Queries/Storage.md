# Azure Resource Graph Queries - Storage

#### List all public-facing storage accounts
```OQL
where type =~ 'microsoft.storage/storageAccounts' and aliases['Microsoft.Storage/storageAccounts/networkAcls.defaultAction'] == 'Allow'
```