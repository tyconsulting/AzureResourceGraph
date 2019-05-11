# Sample Azure CLI Commands

## Pre-requisite
Install Azure CLI as per instructed at [https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)

## Code Sample
~~~Bash
# Sign-in
az login
# enable resource-graph extension if necessary:
az extension add --name resource-graph

# Invoke search
az graph query -q "where type =~ 'microsoft.storage/storageAccounts' and aliases['Microsoft.Storage/storageAccounts/networkAcls.defaultAction'] == 'Allow'" --output table
~~~