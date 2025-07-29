$WarningPreference = "SilentlyContinue"

if (Test-Path "$env:USERPROFILE\myAzContext.json") {
    Import-AzContext -Path "$env:USERPROFILE\myAzContext.json"
} else {
    $context = Connect-AzAccount -DeviceCode
    Save-AzContext -Path "$env:USERPROFILE\myAzContext.json"
}

$subscriptions = Get-AzSubscription
$ExcludedSubscriptionName = "" 

$report = @()

foreach ($subscription in $subscriptions) {
    if ($ExcludedSubscriptionName -ne "" -and $subscription.Name -eq $ExcludedSubscriptionName) {
        Write-Output "Skipping $($subscription.Name)"
        continue
    }
    try {
        Write-Host "Switching to subscription: $($subscription.Name)" -ForegroundColor Cyan
        Set-AzContext -SubscriptionId $subscription.Id | Out-Null
    } catch {
        Write-Warning "Could not access subscription $($subscription.Name). Skipping..."
        continue
    }
    # Set-AzContext -SubscriptionId $subscription.Id | Out-Null
    # Write-Output "Processing subscription: $($subscription.Name)"

    $nics = Get-AzNetworkInterface

    $privateEndpoints = Get-AzPrivateEndpoint
    # $peNicIds = $privateEndpoints.NetworkInterfaces.Id | ForEach-Object { $_.ToLower() }
    $peNicIds = @()
    if ($privateEndpoints) {
        foreach ($pe in $privateEndpoints) {
            foreach ($nicRef in $pe.NetworkInterfaces) {
                $peNicIds += $nicRef.Id.ToLower()
            }
        }
    }

    foreach ($nic in $nics) {
        $attachedToVm = $nic.VirtualMachine -ne $null
        $attachedToPe = $peNicIds -contains $nic.Id.ToLower()

        if (-not $attachedToVm -and -not $attachedToPe) {
            $report += [PSCustomObject]@{
                NICName          = $nic.Name
                ResourceGroup    = $nic.ResourceGroupName
                SubscriptionName = $subscription.Name
                Location         = $nic.Location
                PrivateIP        = $nic.IpConfigurations[0].PrivateIpAddress
                AttachedTo       = "None"
            }
        }
    }
}

if ($report.Count -eq 0) {
    Write-Host "No unattached NICs found across accessible subscriptions."
} else {
    Write-Host "Found $($report.Count) unattached NIC(s):`n"
    $report | Format-Table -AutoSize
}