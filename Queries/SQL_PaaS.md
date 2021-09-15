# Azure Resource Graph Queries - SQL PaaS

### List all SQL PaaS Databases

```OQL
resources
| where type =~ "microsoft.sql/servers/databases"
| where kind notcontains "system"
| extend sku_name = sku.name
| extend sql_server = split(id,"/")[8]
| project name, resource_id=id, sku_name, sql_server, kind, location, resourceGroup, subscriptionId
```
