# Azure Resource Graph PowerShell Script Samples
## Introduction
This page contains sample PowerShell scripts around Azure Resource Graph

## Script Collections
### 1. Invoke Azure Resource Graph REST API using PowerShell
In addition to the Azure PowerShell cmdlet ***Search-AzGraph*** and CLI command ***az graph query***, you can also invoke the Azure Resource Graph API directly using PowerShell.

* **Sample Script:** [InvokeResourceGraphAPI.ps1](../Scripts/InvokeResourceGraphAPI.ps1)

To use this script, you must install the [AzureServicePrincipalAccount](https://www.powershellgallery.com/packages/AzureServicePrincipalAccount/) PowerShell module on your computer first:
~~~PowerShell
Install-Module AzureServicePrincipalAccount -Repository PSGallery -Force
~~~

### 2. Get All subscriptions in a maagement group
When invoking Azure Resource Graph queries, you must provide a list of subscriptions that you wish to query. This is rather static and inflexible. In a large or dynamic environment, when new subscriptions get created frequently, it would be nice if you can target your resource graph query to all subscriptions placed under a management group hierarchy.
This sample script provides a function to retrieve Ids of all subscriptions under one or more management groups.

* **Sample Script:** [GetSubscriptionsbyMG.ps1](../Scripts/GetSubscriptionsbyMG.ps1)

To use this script, you must install the [AzureServicePrincipalAccount](https://www.powershellgallery.com/packages/AzureServicePrincipalAccount/) PowerShell module on your computer first:
~~~PowerShell
Install-Module AzureServicePrincipalAccount -Repository PSGallery -Force
~~~