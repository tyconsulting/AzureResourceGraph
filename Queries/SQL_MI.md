# Azure Resource Graph Queries - SQL Managed Instance

### Detect Newly Created Databases in SQL MI

```OQL
resourceChanges
| extend changeType = properties.changeType
| extend targetResourceType = properties.targetResourceType
| extend timestamp = properties.changeAttributes.timestamp
| extend targetResourceId = properties.targetResourceId
| where changeType =~ "create" and targetResourceType =~ 'microsoft.sql/managedinstances/databases'
| extend databaseName = split(targetResourceId, "/")[10]
| extend serverName = split(targetResourceId, "/")[8]
| project databaseName, targetResourceId, serverName, resourceGroup, location, subscriptionId, timestamp
```
