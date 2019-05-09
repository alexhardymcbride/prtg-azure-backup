# PRTG Azure Backup Sensor

This powershell script is used to monitor the status of Azure VM backup jobs in an Azure Recovery Services Vault as a PRTG Network Monitor custom sensor.

You can find out more about PRTG here: https://www.paessler.com/prtg.

## Usage

To use this script with your PRTG installation, follow these steps:
1. Save the script file "asrbackupstatus.ps1" in the %prtginstalldir%\Custom Sensors\EXEXML\ directory on your monitoring probe.
2. Set the Powershell (x86) ExecutionPolicy setting to RemoteSigned on the probe server.
3. Install the AzureRM powershell module in Powershell (x86) on the probe server.
4. Create a device in PRTG (use any value for the hostname field, it won't be used by this sensor), then add a new "EXE/Script Advanced" sensor.
5. From the EXE/Script dropdown, choose "asrbackupstatus.ps1".
6. In the Parameters section, insert the text "-$AccountName %linuxuser -Vault *Recovery Services Vault Name* -PW %linuxpassword".
7. Configure a Service Principal in Azure with at least "Reader" permissions on the Recovery Services Vault. Save the application id in the Linux "User" credentials field in PRTG, and a valid key in  the Linux "Password" field.
8. Save the lookups file "prtg.customlookups.azure.backupjobstatus.ovl" in the %prtginstalldir%\lookups\custom\ directory on your PRTG core server.
9. On PRTG's Administrative Tools page, click the "Load Lookups" button. 

If any further troubleshooting is required, please check this KB on configuring PRTG with custom powershell scripts: https://kb.paessler.com/en/topic/71356-guide-for-powershell-based-custom-sensors.
