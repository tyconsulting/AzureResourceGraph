# Azure Resource Graph Queries - Compute

#### Get all Log Analytics workspaces
```OQL
where type =~ 'microsoft.operationalinsights/workspaces'
```

#### Get all Azure Monitor Scheduled Query rules
```OQL
where type =~ 'microsoft.insights/scheduledueryrules'
```

#### Get all Azure Monitor Action Groups
```OQL
where type =~ 'microsoft.insights/actiongroups'
```
