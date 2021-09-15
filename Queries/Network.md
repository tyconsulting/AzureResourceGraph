# Azure Resource Graph Queries - Networking

### List all inbound rules in a NSG

```OQL
resources
| where type =~ "microsoft.network/networksecuritygroups"
| where name contains "nsg"
| join kind=leftouter (resourcecontainers | where type =='microsoft.resources/subscriptions' | project SubscriptionName=name, subscriptionId) on subscriptionId
|mv-expand rules=properties.securityRules
|where rules.properties.direction =~"inbound"
|extend direction=tostring(rules.properties.direction)
|extend priority=toint(rules.properties.priority)
|extend rule_name = rules.name
|extend source_asgs=parse_json(rules.properties.sourceApplicationSecurityGroups)
|extend destination_asgs=parse_json(rules.properties.destinationApplicationSecurityGroups)
|extend description=rules.properties.description
|extend destination_prefix=iif(isempty(rules.properties.destinationAddressPrefixes), rules.properties.destinationAddressPrefix, rules.properties.destinationAddressPrefixes)
|extend destination_asgs=iif(isempty(rules.properties.destinationApplicationSecurityGroups), '', destination_asgs)
|extend destination=iif(isempty(destination_asgs), destination_prefix, destination_asgs)
|extend destination=iif(destination=='[]', "Any", destination)
|extend destination_port=rules.properties.destinationPortRange
|extend source_prefix=iif(isempty(rules.properties.sourceAddressPrefixes), rules.properties.sourceAddressPrefix, rules.properties.sourceAddressPrefixes)
|extend source_asgs=iif(isempty(rules.properties.sourceApplicationSecurityGroups), "", source_asgs)
|extend source=iif(isempty(source_asgs), source_prefix, tostring(source_asgs))
|extend source=iif(source=='[]', 'Any', source)
|extend source_port=rules.properties.sourcePortRange
|extend action=rules.properties.access
|extend subnet_name = split((split(tostring(properties.subnets), '/'))[10], '"')[0]
|project SubscriptionName, resourceGroup, subnet_name, name, direction, priority, action, source, source_port, destination, destination_port, description, subscriptionId
|sort by SubscriptionName, resourceGroup asc, name, direction asc, priority asc
```
