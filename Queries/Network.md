# Azure Resource Graph Queries - Networking

### List all inbound and outbound NSG rules by subnets

```OQL
resources
| where type =~ "microsoft.network/networksecuritygroups"
| join kind=leftouter (resourcecontainers | where type =='microsoft.resources/subscriptions' | project SubscriptionName=name, subscriptionId) on subscriptionId
|mv-expand rules=properties.securityRules
|extend direction=tostring(rules.properties.direction)
|extend priority=toint(rules.properties.priority)
|extend rule_name = rules.name
|extend description=rules.properties.description
|extend destination_prefix=iif(rules.properties.destinationAddressPrefixes=='[]', rules.properties.destinationAddressPrefix, rules.properties.destinationAddressPrefixes)
|extend destination_asgs=iif(isempty(rules.properties.destinationApplicationSecurityGroups), '', split((split(tostring(parse_json(rules.properties.destinationApplicationSecurityGroups)), '/'))[8], '"')[0])
|extend destination=iif(isempty(destination_asgs), destination_prefix, destination_asgs)
|extend destination=iif(destination=='*', "Any", destination)
|extend destination_port=iif(isempty(rules.properties.destinationPortRange), strcat_array(rules.properties.destinationPortRanges,","), rules.properties.destinationPortRange)
|extend source_prefix=iif(rules.properties.sourceAddressPrefixes=='[]', rules.properties.sourceAddressPrefix, rules.properties.sourceAddressPrefixes)
|extend source_asgs=iif(isempty(rules.properties.sourceApplicationSecurityGroups), "", split((split(tostring(parse_json(rules.properties.sourceApplicationSecurityGroups)), '/'))[8], '"')[0])
|extend source=iif(isempty(source_asgs), source_prefix, tostring(source_asgs))
|extend source=iif(source=='*', 'Any', source)
|extend source_port=iif(isempty(rules.properties.sourcePortRange), strcat_array(rules.properties.sourcePortRanges,","), rules.properties.sourcePortRange)
|extend action=rules.properties.access
|extend subnets = properties.subnets
|mv-expand subnets
|project SubscriptionName, resourceGroup, subnet_name = split((split(tostring(subnets.id), '/'))[10], '"')[0], name, direction, priority, action, source, source_port, destination, destination_port, description, subscriptionId,rules.properties.sourceAddressPrefix, rules.properties.sourceAddressPrefixes
|sort by SubscriptionName, resourceGroup asc, name, direction asc, priority asc
```
