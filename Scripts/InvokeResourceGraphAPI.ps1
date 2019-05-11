#Requires -Version 5.0
#Requires -Modules AzureServicePrincipalAccount
<#
  =============================================================
  AUTHOR:  Tao Yang 
  DATE:    11/05/2019
  Version: 1.0
  Comment: Invoke Azure Resource Graph API using PowerShell
  =============================================================
#>

#region functions
Function InvokeResourceGraphQuery
{
  Param (
    [Parameter(Mandatory = $true)][Hashtable]$RequestHeaders,
    [Parameter(Mandatory = $true)][string]$Query,
    [Parameter(Mandatory = $true)][string[]]$subscriptions
  )
  $URI = "https://management.azure.com/providers/Microsoft.ResourceGraph/resources?api-version=2018-09-01-preview"
  #Construct Request body
  $objRequestBody = new-object System.Management.Automation.PSObject -Property @{subscriptions = $subscriptions;query = $query}
  $jsonRequestBody = ConvertTo-Json -InputObject $objRequestBody -Depth 5
  Try {
    $SearchRequest = Invoke-WebRequest -UseBasicParsing -Uri $URI -Headers $RequestHeaders -Body $jsonRequestBody -Method POST -ContentType "application/json"

    If ($SearchRequest.StatusCode -ge 200 -and $SearchRequest.StatusCode -le 299)
    {
      #parse search result
        $data = ConvertFrom-Json $SearchRequest.content
        $count = 0
        foreach ($item in $data.data) {
            $count += $item.Rows.Count
        }

        $SearchResult = New-Object object[] $count
        $i = 0;
        foreach ($item in $data.data) {
            foreach ($row in $item.Rows) {
                # Create a dictionary of properties
                $properties = @{}
                for ($columnNum=0; $columnNum -lt $item.Columns.Count; $columnNum++) {
                    $properties[$item.Columns[$columnNum].name] = $row[$columnNum]
                }
                # Then create a PSObject from it. This seems to be *much* faster than using Add-Member
                $SearchResult[$i] = (New-Object PSObject -Property $properties)
                $null = $i++
            }
        }
      }
    } Catch {
        Throw $_.Exception
    }
  $SearchResult
}
#endregion

#region main
#variables - change it to according to your environment
$AzureSubs = "35cf4ca5-98e1-4c63-936f-9350c4f14bbc", "148dad05-53a2-43fb-bd71-777625cd1dab"
$TenantId = "195312e9-6433-4dfd-b3cd-583af317cae3"
#Get AAD Token
Write-Verbose "Requesting Azure AD oAuth tokens"
$ARMToken = Get-AzureADToken -TenantId $TenantId
$ARMRequestHeaders = @{'Authorization' = $ARMToken}

#Invoke Resource Graph Query
$query = "where type =~ 'microsoft.operationalinsights/workspaces'"

$result = InvokeResourceGraphQuery -RequestHeaders $ARMRequestHeaders -Query $query -subscriptions $AzureSubs
$result