# Azure Resource Graph Queries - Storage

#### List all public-facing storage accounts

```OQL
resources
| where type =~ 'microsoft.storage/storageAccounts'
| extend networkACLs_defaultAction=parse_json(properties.networkAcls).defaultAction
| where networkACLs_defaultAction =~ 'allow'
```

#### List all storage accounts that have Service Endpoint enabled

```OQL
resources
| where type =~ 'microsoft.storage/storageAccounts'
| extend networkACLs_defaultAction=parse_json(properties.networkAcls).defaultAction
| where networkACLs_defaultAction =~ 'deny'
```

### List all storage accounts that do not use customer-managed encryption keys

```OQL
Resources | where type =~ 'microsoft.storage/storageaccounts' and aliases['Microsoft.Storage/storageAccounts/encryption.keySource'] =~ 'microsoft.storage' | extend keySource = properties.encryption.keySource | project id,name,kind,location,resourceGroup,subscriptionId,keySource
```

### List all storage accounts that use customer-managed encryption keys

```OQL
Resources | where type =~ 'microsoft.storage/storageaccounts' and aliases['Microsoft.Storage/storageAccounts/encryption.keySource'] !~ 'microsoft.storage' | extend keySource = properties.encryption.keySource | project id,name,kind,location,resourceGroup,subscriptionId,keySource
```
