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