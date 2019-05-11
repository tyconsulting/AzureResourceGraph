#Requires -Version 5.0
#Requires -Modules AzureServicePrincipalAccount
<#
  ===============================================================
  AUTHOR:  Tao Yang 
  DATE:    11/05/2019
  Version: 1.0
  Comment: Get subscriptions under one or more management groups
  ===============================================================
#>

#region functions
Function GetAzureSubscriptionsbyMG
{
  [CmdletBinding()]
  Param (
    [Parameter(Mandatory = $true)][Hashtable]$RequestHeaders,
    [Parameter(Mandatory = $true)][string[]]$ManagementGroupName
  )
  $subs = New-Object System.Collections.ArrayList
  Foreach ($MG in $ManagementGroupName)
  {
    $URI = "https://management.azure.com/providers/microsoft.management/getEntities?api-version=2018-03-01-preview&`$filter=`"name eq '$MG'`""
    
    Try {
      $GetEntitiesResponse = Invoke-WebRequest -UseBasicParsing -Uri $URI -Headers $RequestHeaders -Method POST
  
      If ($GetEntitiesResponse.StatusCode -ge 200 -and $GetEntitiesResponse.StatusCode -le 299)
      {
        foreach ($item in (ConvertFrom-Json $GetEntitiesResponse.Content).value)
        {
          if ($item.type -ieq '/subscriptions' -and (!$subs.Contains($item.name)))
          {
            [void]$subs.Add($item.name)
          }
        }
      }
    } Catch {
      Throw $_.Exception
    }

  }
  $Subs
}
#endregion

#region main
#variables - change it to according to your environment
$managementGroupName = 'mg1', 'mg2'
$TenantId = "195312e9-6433-4dfd-b3cd-583af317cae3"
#Get AAD Token
Write-Verbose "Requesting Azure AD oAuth tokens"
$ARMToken = Get-AzureADToken -TenantId $TenantId
$ARMRequestHeaders = @{'Authorization' = $ARMToken}

#Get all subscription Ids in under the MG hireachy. Need these IDs for the Resource Graph query
$AzureSubs = GetAzureSubscriptionsbyMG -RequestHeaders $ARMRequestHeaders -ManagementGroupName $managementGroupName
$ofs = ", "
Write-OUtput "Azure subscriptions in management group $managementGroupName`: $AzureSubs"