# Azure Resource Graph Queries - Role Assignments

#### List all Owner Role Assignments by subscriptions including inherited assignments

```OQL
resourcecontainers
| where type =~ 'microsoft.resources/subscriptions'
| extend  mgParent = properties.managementGroupAncestorsChain
| extend subScope = pack_array(subscriptionId)
| extend rootScope = pack_array('/')
| extend scopes=array_concat(mgParent, subScope, rootScope)
| mv-expand scopes
| extend  scopeName=iff(isempty(tostring(scopes.name)), tostring(scopes), scopes.name)
| project subscriptionId, name, scopes, scopeName
| join kind=inner (
    authorizationresources
    | where type =~ 'microsoft.authorization/roleAssignments'
    | extend roleDefinitionId = properties.roleDefinitionId
    | where roleDefinitionId =~ '/providers/Microsoft.Authorization/RoleDefinitions/8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
    | extend scope = tostring(properties['scope'])
    | extend mgOrRootScope = iff(scope =='/', scope, (tostring((split(scope, '/', 4))[0])))
    | extend scopeName = iff(isempty(mgOrRootScope), subscriptionId, mgOrRootScope)
    | extend principalType = tostring(properties['principalType'])
    | extend principalId = tostring(properties['principalId'])
    | project id, principalId, principalType, scope, scopeName, roleDefinitionId
) on $left.scopeName == $right.scopeName
| project id, subscriptionName = name, scope, roleDefinitionId, principalType, principalId, scopeName
| summarize count() by subscriptionName
```