param (
    [string]$AccountName,
    [string]$Vault,
    [string]$PW,
    [string]$TenantID
    )

Import-Module AzureRM

#Authentication - Change this section if using script on a different tenancy.
$azurePassword = ConvertTo-SecureString $PW -AsPlainText -Force
$psCred = New-Object System.Management.Automation.PSCredential($AccountName, $azurePassword)
Add-AzureRmAccount -Credential $psCred -TenantId $TenantID -ServicePrincipal | Out-Null

#Find the Backup Vault and move Powershell to that context
Get-AzureRmRecoveryServicesVault -Name $Vault | Set-AzureRmRecoveryServicesVaultContext | Out-Null

#Find VMs
$backupitems = Get-AzureRmRecoveryServicesBackupItem -BackupManagementType AzureVM -WorkloadType AzureVM
$channels = @()

foreach ($backupitem in $backupitems) {
    #Check VM's backup status
    $backupitem.LastBackupStatus
    $timediff = (get-date) - $backupitem.LastBackupTime
    $timedays = [timespan]::fromdays(1)

    if ($backupitem.LastBackupStatus -like "Completed" -and $timediff -lt $timedays) {$output = 0}
    elseif ($backupitem.LastBackupStatus -like "Completed") {$output = 1}
    else  {$output = 2}

    $name = $backupitem.Name.split(";")[3]

    #Construct the XJSON output to PRTG
    $channel = @{"Channel" = $name;"Value" = $output;"Unit" = "Custom";"customunit" = "Backup Status";"ValueLookup" = "prtg.customlookups.azure.backupjobstatus"}
    $channels += $channel
}

Write-Output (@{"prtg" = (@{"result" = $channels})} | ConvertTo-JSON -Depth 3)

Logout-AzureRmAccount | Out-Null