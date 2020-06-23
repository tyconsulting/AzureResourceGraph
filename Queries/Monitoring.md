# Azure Resource Graph Queries - Monitoring

#### Get all Log Analytics workspaces

```OQL
where type =~ 'microsoft.operationalinsights/workspaces'
```

#### List name, workspace Id, retention, resource group, subscription and location for all Log Analytics workspaces

```OQL
where type =~ 'microsoft.operationalinsights/workspaces'
| project name, WorkspaceId=properties.customerId, RetentionInDays=properties.retentionInDays, resourceGroup, location, subscriptionId
```

#### Get all Azure Monitor Scheduled Query rules

```OQL
where type =~ 'microsoft.insights/scheduledueryrules'
```

#### Get all Azure Monitor Action Groups

```OQL
where type =~ 'microsoft.insights/actiongroups'
```
