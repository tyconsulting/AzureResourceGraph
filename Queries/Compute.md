# Azure Resource Graph Queries - Compute

#### List all Windows server VM that has Hybrid Use Benefit enabled
~~~Query
where type =~ 'microsoft.compute/virtualMachines' and aliases['Microsoft.Compute/imageOffer'] == 'WindowsServer' and aliases['Microsoft.Compute/licenseType'] == 'Windows_Server'
~~~

#### List all Windows server VM that are not using Hybrid Use Benefit
~~~Query
where type =~ 'microsoft.compute/virtualMachines' and aliases['Microsoft.Compute/imageOffer'] == 'WindowsServer' and aliases['Microsoft.Compute/licenseType'] != 'Windows_Server'
~~~
