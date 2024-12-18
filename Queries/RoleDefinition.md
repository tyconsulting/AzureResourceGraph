# Azure Resource Graph Queries - Role Definitions

#### List all Custom Roles

```OQL
authorizationresources
| where type == "microsoft.authorization/roledefinitions"
| project id, name, roleName=tostring(properties.roleName), roleType=tostring(properties.type)
| where roleType =~ 'CustomRole'
| sort by roleName
```
