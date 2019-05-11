# Azure Resource Graph REST API
## Introduction
The Azure Resource Graph API is part of the Azure Resource Manager (ARM) REST API. It is fully documented at Microsoft's documentation here: [https://docs.microsoft.com/en-us/rest/api/azure-resourcegraph/](https://docs.microsoft.com/en-us/rest/api/azure-resourcegraph/).

## Instruction
The HTTP endpoint for the  Resource Graph REST API is:
~~~
POST https://management.azure.com/providers/Microsoft.ResourceGraph/resources?api-version=2019-04-01
~~~

Like other ARM REST APIs, when invoking the Resource Graph REST API, you will need to insert an Azure AD OAuth bearer token into the authorization header of the HTTP request.

The HTTP request body must include the list of subscriptions you are trying to query, together with the actual Resource Graph query itself. For example:
```JSON
{
  "subscriptions": [
    "35cf4ca5-98e1-4c63-936f-9350c4f14bbc",
    "148dad05-53a2-43fb-bd71-777625cd1dab"
  ],
  "query": "where type =~ 'microsoft.storage/storageAccounts' and aliases['Microsoft.Storage/storageAccounts/networkAcls.defaultAction'] == 'Allow'"
}
```
The HTTP response contains the search result. Like any other Kusto language based API, the search result is seperated by columns and rows (as shown below). You will need to programatically parse the result in a more readable format.

```JSON
{
    "totalRecords": 2,
    "count": 2,
    "data": {
        "columns": [
            {
                "name": "type",
                "type": "string"
            },
            {
                "name": "id",
                "type": "string"
            },
            {
                "name": "sku",
                "type": "object"
            },
            {
                "name": "name",
                "type": "string"
            },
            {
                "name": "kind",
                "type": "string"
            },
            {
                "name": "plan",
                "type": "object"
            },
            {
                "name": "tags",
                "type": "object"
            },
            {
                "name": "location",
                "type": "string"
            },
            {
                "name": "properties",
                "type": "object"
            },
            {
                "name": "resourceGroup",
                "type": "string"
            },
            {
                "name": "subscriptionId",
                "type": "string"
            },
            {
                "name": "managedBy",
                "type": "string"
            },
            {
                "name": "identity",
                "type": "object"
            },
            {
                "name": "zones",
                "type": "object"
            },
            {
                "name": "tenantId",
                "type": "string"
            }
        ],
        "rows": [
            [
                "microsoft.storage/storageaccounts",
                "/subscriptions/35cf4ca5-98e1-4c63-936f-9350c4f14bbc/resourceGroups/cloud-shell-storage-southeastasia/providers/Microsoft.Storage/storageAccounts/cs1a443bc8a7305x4bb5xabc",
                {
                    "name": "Standard_LRS",
                    "tier": "Standard"
                },
                "cs1a443bc8a7305x4bb5xabc",
                "Storage",
                null,
                {
                    "ms-resource-usage": "azure-cloud-shell"
                },
                "southeastasia",
                {
                    "provisioningState": "Succeeded",
                    "supportsHttpsTrafficOnly": false,
                    "creationTime": "2017-11-22T07:10:53.7940000Z",
                    "primaryEndpoints": {
                        "blob": "https://cs1a443bc8a7305x4bb5xabc.blob.core.windows.net/",
                        "file": "https://cs1a443bc8a7305x4bb5xabc.file.core.windows.net/",
                        "table": "https://cs1a443bc8a7305x4bb5xabc.table.core.windows.net/",
                        "queue": "https://cs1a443bc8a7305x4bb5xabc.queue.core.windows.net/"
                    },
                    "statusOfPrimary": "available",
                    "primaryLocation": "southeastasia",
                    "networkAcls": {
                        "virtualNetworkRules": [],
                        "defaultAction": "Allow",
                        "ipRules": [],
                        "bypass": "AzureServices"
                    },
                    "encryption": {
                        "keySource": "Microsoft.Storage",
                        "services": {
                            "blob": {
                                "lastEnabledTime": "2017-12-07T22:07:13.3220000Z",
                                "enabled": true
                            },
                            "file": {
                                "lastEnabledTime": "2017-12-07T22:07:13.3220000Z",
                                "enabled": true
                            }
                        }
                    }
                },
                "cloud-shell-storage-southeastasia",
                "35cf4ca5-98e1-4c63-936f-9350c4f14bbc",
                "",
                "",
                null,
                "2d230faf-8422-497b-90e2-7f39a017c99e"
            ],
            [
                "microsoft.storage/storageaccounts",
                "/subscriptions/148dad05-53a2-43fb-bd71-777625cd1dab/resourceGroups/rg-vm-boot-diag/providers/Microsoft.Storage/storageAccounts/tybootdiag",
                {
                    "name": "Standard_RAGRS",
                    "tier": "Standard"
                },
                "tybootdiag",
                "StorageV2",
                null,
                {},
                "australiasoutheast",
                {
                    "provisioningState": "Succeeded",
                    "supportsHttpsTrafficOnly": true,
                    "creationTime": "2019-04-18T00:38:02.6880000Z",
                    "primaryEndpoints": {
                        "blob": "https://tybootdiag.blob.core.windows.net/",
                        "file": "https://tybootdiag.file.core.windows.net/",
                        "table": "https://tybootdiag.table.core.windows.net/",
                        "queue": "https://tybootdiag.queue.core.windows.net/",
                        "dfs": "https://tybootdiag.dfs.core.windows.net/",
                        "web": "https://tybootdiag.z26.web.core.windows.net/"
                    },
                    "statusOfPrimary": "available",
                    "primaryLocation": "australiasoutheast",
                    "networkAcls": {
                        "virtualNetworkRules": [
                            {
                                "id": "/subscriptions/148dad05-53a2-43fb-bd71-777625cd1dab/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-spoke01/subnets/ResourceSubnet1",
                                "state": "Succeeded",
                                "action": "Allow"
                            }
                        ],
                        "defaultAction": "Allow",
                        "ipRules": [],
                        "bypass": "AzureServices"
                    },
                    "encryption": {
                        "keySource": "Microsoft.Storage",
                        "services": {
                            "blob": {
                                "lastEnabledTime": "2019-04-18T00:38:02.8910000Z",
                                "enabled": true
                            },
                            "file": {
                                "lastEnabledTime": "2019-04-18T00:38:02.8910000Z",
                                "enabled": true
                            }
                        }
                    },
                    "accessTier": "Hot",
                    "statusOfSecondary": "available",
                    "secondaryLocation": "australiaeast",
                    "secondaryEndpoints": {
                        "blob": "https://tybootdiag-secondary.blob.core.windows.net/",
                        "table": "https://tybootdiag-secondary.table.core.windows.net/",
                        "queue": "https://tybootdiag-secondary.queue.core.windows.net/",
                        "dfs": "https://tybootdiag-secondary.dfs.core.windows.net/",
                        "web": "https://tybootdiag-secondary.z26.web.core.windows.net/"
                    }
                },
                "rg-vm-boot-diag",
                "148dad05-53a2-43fb-bd71-777625cd1dab",
                "",
                "",
                null,
                "2d230faf-8422-497b-90e2-7f39a017c99e"
            ]
        ]
    },
    "facets": [],
    "resultTruncated": "false"
}
```