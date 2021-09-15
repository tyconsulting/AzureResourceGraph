# Azure Resource Graph Queries - Compute

#### List all Windows server VM that has Hybrid Use Benefit enabled

```OQL
where type =~ 'microsoft.compute/virtualMachines' and aliases['Microsoft.Compute/imageOffer'] == 'WindowsServer' and aliases['Microsoft.Compute/licenseType'] == 'Windows_Server'
```

#### List all Windows server VM that are not using Hybrid Use Benefit

```OQL
where type =~ 'microsoft.compute/virtualMachines' and aliases['Microsoft.Compute/imageOffer'] == 'WindowsServer' and aliases['Microsoft.Compute/licenseType'] != 'Windows_Server'
```

### Count Virtual Machines by image offer and location

```OQL
where type =~ 'microsoft.compute/virtualMachines' | summarize count() by tostring(properties.storageProfile.imageReference.offer), location
```

### Count Virtual Machines by VM Size and location

```OQL
where type =~ 'microsoft.compute/virtualMachines' | summarize count() by tostring(properties.hardwareProfile.vmSize), location
```

#### List All Virtual Machines with the subnet, private and public IPs (only support single IPconfig per NIC)

```OQL
Resources
| where type =~ 'microsoft.compute/virtualmachines'
| extend nics=array_length(properties.networkProfile.networkInterfaces)
| mv-expand nic=properties.networkProfile.networkInterfaces
| where nics == 1 or nic.properties.primary =~ 'true' or isempty(nic)
| project vmId = id, resourceGroup = resourceGroup, vmName = name, osType=tostring(properties.storageProfile.osDisk.osType), osName=tostring(properties.extended.instanceView.osName), osVersion=tostring(properties.extended.instanceView.osVersion), vmSize=tostring(properties.hardwareProfile.vmSize), nicId = tostring(nic.id)
| join kind=leftouter (
    Resources
    | where type =~ 'microsoft.network/networkinterfaces'
    | extend ipConfigsCount=array_length(properties.ipConfigurations)
    | mv-expand ipconfig=properties.ipConfigurations
    | where ipConfigsCount == 1 or ipconfig.properties.primary =~ 'true'
    | project nicId = id, subnetId = tostring(ipconfig.properties.subnet.id), privateIpAddress = tostring(ipconfig.properties.privateIPAddress), publicIpId = tostring(ipconfig.properties.publicIPAddress.id))
on nicId
| project-away nicId1
| summarize by vmId, vmName, resourceGroup, osType, osName, osVersion, vmSize, nicId, subnetId, privateIpAddress, publicIpId
| join kind=leftouter (
    Resources
    | where type =~ 'microsoft.network/publicipaddresses'
    | project publicIpId = id, publicIpAddress = properties.ipAddress)
on publicIpId
| project-away publicIpId1
```

### List Virtual Machines with the Azure Monitor Agent VM Extension and the Log Analytics Workspace it connects to

```OQL
Resources
| where type == 'microsoft.compute/virtualmachines'
| extend
    JoinID = toupper(id),
    OSName = tostring(properties.osProfile.computerName),
    OSType = tostring(properties.storageProfile.osDisk.osType),
    VMLocation = location,
    VMResourceGroup = resourceGroup
| join kind=leftouter(
    Resources
    | where type == 'microsoft.compute/virtualmachines/extensions' and aliases['Microsoft.Compute/virtualMachines/extensions/type'] in ('MicrosoftMonitoringAgent', 'OmsAgentForLinux')
    | extend 
        VMId = toupper(substring(id, 0, indexof(id, '/extensions'))),
        ExtensionName = name,
        workspaceId = tostring(properties.settings.workspaceId)
) on $left.JoinID == $right.VMId
| summarize by id, OSName, OSType, VMLocation, VMResourceGroup, ExtensionName, workspaceId
| order by tolower(OSName) asc
```

### Count SQL Virtual Machines by Resource Group

```OQL
Resources
| where type == 'microsoft.sqlVirtualMachines/sqlVirtualMachines'
| summarize count() by ResourceGroup
```