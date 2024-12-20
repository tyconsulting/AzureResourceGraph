# Azure Resource Graph Queries - Networking

### List all inbound and outbound NSG rules

```OQL
resources
| where type =~ "microsoft.network/networksecuritygroups"
| join kind=leftouter (resourcecontainers | where type =='microsoft.resources/subscriptions' | project SubscriptionName=name, subscriptionId) on subscriptionId
|mv-expand rules=properties.securityRules
|extend direction=tostring(rules.properties.direction)
|extend priority=toint(rules.properties.priority)
|extend rule_name = rules.name
|extend nsg_name = name
|extend description=rules.properties.description
|extend destination_prefix=iif(rules.properties.destinationAddressPrefixes=='[]', rules.properties.destinationAddressPrefix, strcat_array(rules.properties.destinationAddressPrefixes, ","))
|extend destination_asgs=iif(isempty(rules.properties.destinationApplicationSecurityGroups), '', strcat_array(parse_json(rules.properties.destinationApplicationSecurityGroups), ","))
|extend destination=iif(isempty(destination_asgs), destination_prefix, destination_asgs)
|extend destination=iif(destination=='*', "Any", destination)
|extend destination_port=iif(isempty(rules.properties.destinationPortRange), strcat_array(rules.properties.destinationPortRanges,","), rules.properties.destinationPortRange)
|extend source_prefix=iif(rules.properties.sourceAddressPrefixes=='[]', rules.properties.sourceAddressPrefix, strcat_array(rules.properties.sourceAddressPrefixes, ","))
|extend source_asgs=iif(isempty(rules.properties.sourceApplicationSecurityGroups), "", strcat_array(parse_json(rules.properties.sourceApplicationSecurityGroups), ","))
|extend source=iif(isempty(source_asgs), source_prefix, tostring(source_asgs))
|extend source=iif(source=='*', 'Any', source)
|extend source_port=iif(isempty(rules.properties.sourcePortRange), strcat_array(rules.properties.sourcePortRanges,","), rules.properties.sourcePortRange)
|extend action=rules.properties.access
|extend subnets = strcat_array(properties.subnets, ",")
|project SubscriptionName, resourceGroup, nsg_name, rule_name, subnets, direction, priority, action, source, source_port, destination, destination_port, description, subscriptionId, id
|sort by SubscriptionName, resourceGroup asc, nsg_name, direction asc, priority asc
```

### List all Network Security Groups and NSG Flow Logs Configuration

```OQL
Resources
| where type =~ 'microsoft.network/networksecuritygroups'
| extend nsgId = id
| extend nsgName = name
| extend nsgLocation = location
| join kind=leftouter (resourcecontainers | where type =='microsoft.resources/subscriptions' | project subscriptionName=name, subscriptionId) on subscriptionId
| join kind=leftouter (
    Resources
    | where type =~ 'microsoft.network/networkwatchers/flowlogs'
    | project flowLogName = name, flowLogId=id, flowLogEnabled = properties.enabled, flowLogStorageId = properties.storageId, flowLogTrafficAnalyticsEnabled = properties.flowAnalyticsConfiguration.networkWatcherFlowAnalyticsConfiguration.enabled, flowLogLogAnalyticsId = properties.flowAnalyticsConfiguration.networkWatcherFlowAnalyticsConfiguration.workspaceResourceId, nsgId = tostring(properties.targetResourceId))
on nsgId
| project nsgId, nsgName, nsgLocation, subscriptionName, flowLogId, flowLogName, flowLogEnabled, flowLogStorageId, flowLogTrafficAnalyticsEnabled, flowLogLogAnalyticsId
```

#### List all Subnets that have Service Endpoints enabled

```OQL
Resources
| where type == 'microsoft.network/virtualnetworks'
| extend subnets = properties.subnets
| mv-expand subnets
| extend serviceEndpoints = subnets.properties.serviceEndpoints
| where array_length(serviceEndpoints) != 0 and isnotnull(serviceEndpoints)
| project vnet=name, subnet=subnets.name, addressPrefix=subnets.properties.addressPrefix, location, resourceGroup, subscriptionId, serviceEndpoints
```
