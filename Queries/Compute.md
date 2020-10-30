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
