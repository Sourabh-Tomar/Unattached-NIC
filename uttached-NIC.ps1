Connect-AzAccount 


$TenantId = "aa81de5e-ffef-4e67-954b-f82857df531f"  
$ExcludedSubscriptionName = ""                 


$subscriptions = Get-AzSubscription -TenantId $TenantId


$report = @()

foreach ($subscription in $subscriptions) {

    if ($subscription.Name -eq $ExcludedSubscriptionName) {
        Write-Output "Skipping $($subscription.Name)"
        continue
    }

    Set-AzContext -SubscriptionId $subscription.Id | Out-Null
    Write-Output "Checking subscription: $($subscription.Name)"


    $nics = Get-AzNetworkInterface | Where-Object { $_.VirtualMachine -eq $null }

    foreach ($nic in $nics) {
        if ($nic.Name -like "*-pe-nic*") {
            continue
        }

        $report += [PSCustomObject]@{
            NICName          = $nic.Name
            ResourceGroup    = $nic.ResourceGroupName
            SubscriptionName = $subscription.Name
            Location         = $nic.Location
            PrivateIP        = $nic.IpConfigurations[0].PrivateIpAddress
        }
    }
}

$report | Format-Table -AutoSize
