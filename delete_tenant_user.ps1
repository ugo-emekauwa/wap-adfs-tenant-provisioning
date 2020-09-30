# Delete Tenant User in Windows Azure Pack Script v2, written by Ugo Emekauwa (uemekauw@cisco.com or uemekauwa@gmail.com)

# Start Script
Write-Output "`r`n$(Get-Date) - Starting 'Delete Tenant User in Windows Azure Pack Script v2'." | Out-File -Append "c:\scripts\delete_tenant_user.log"

# Import Required Modules for SCVMM and WAP
Write-Output "$(Get-Date) - Importing required modules for SCVMM and WAP." | Out-File -Append "c:\scripts\delete_tenant_user.log"
Import-Module virtualmachinemanager
Import-Module virtualmachinemanagercore
Import-Module MgmtSvcAdmin

# Set Administrator Credentials for Active Directory, SCVMM and WAP
Write-Output "$(Get-Date) - Setting Administrator credentials for Active Directory, SCVMM and WAP." | Out-File -Append "c:\scripts\delete_tenant_user.log"
$Admin = "domain\Administrator"
$Password = "Password" | ConvertTo-SecureString -AsPlainText -Force
$AdminCred = New-Object System.Management.Automation.PSCredential($Admin,$Password)

# Identify Tenant User's SAM Account Name from Active Directory
Write-Output "$(Get-Date) - Identifying tenant user's SAM account name from Active Directory." | Out-File -Append "c:\scripts\delete_tenant_user.log"
$ADUserSAM = "sampleuser"

# Set SCVMM Environment Specific Variables
Write-Output "$(Get-Date) - Setting SCVMM environment specific variables." | Out-File -Append "c:\scripts\delete_tenant_user.log"
$SCVMMServer = "scvmm1.domain.org"

# Establish Connection to SCVMM
Write-Output "$(Get-Date) - Establishing connection to $($SCVMMServer)." | Out-File -Append "c:\scripts\delete_tenant_user.log"
Get-SCVMMServer -ComputerName $SCVMMServer -Credential $AdminCred

# Define Tenant User in SCVMM
Write-Output "$(Get-Date) - Defining tenant user in SCVMM for AD user $($ADUserSAM)." | Out-File -Append "c:\scripts\delete_tenant_user.log"
$SCVMMUser = $ADUserSAM

# Delete Tenant User Cloud Resources in SCVMM
Write-Output "$(Get-Date) - Deleting tenant user cloud resources in SCVMM for AD user $($ADUserSAM)." | Out-File -Append "c:\scripts\delete_tenant_user.log"
$User_Resources = Get-CloudResource | Where-Object Owner -Match $SCVMMUser
ForEach ($User_Resource in $User_Resources)
{ Remove-CloudResource -CloudResource $User_Resource }

# Delete Tenant User Owned VMs in SCVMM
Write-Output "$(Get-Date) - Deleting tenant user owned VMs in SCVMM for AD user $($ADUserSAM)." | Out-File -Append "c:\scripts\delete_tenant_user.log"
$Owned_VMs = Get-SCVirtualMachine | Where-Object Owner -Match $SCVMMUser
ForEach ($Owned_VM in $Owned_VMs)
{ Stop-SCVirtualMachine -VM $Owned_VM -Force }
ForEach ($Owned_VM in $Owned_VMs)
{ Remove-SCVirtualMachine -VM $Owned_VM }

# Set WAP Environment Specific Variables
Write-Output "$(Get-Date) - Setting WAP environment specific variables." | Out-File -Append "c:\scripts\delete_tenant_user.log"
$WAPServer = "wap1.domain.org"

# Establish Connection to WAP
Write-Output "$(Get-Date) - Establishing connection to $($WAPServer)." | Out-File -Append "c:\scripts\delete_tenant_user.log"
$AdminURI = "https://" + $WAPServer + ":30004"
$AuthSite = "https://" + $WAPServer + ":30072"
$ClientRealm = "http://azureservices/AdminSite"
$Token = Get-MgmtSvcToken -Type Windows -AuthenticationSite $AuthSite -ClientRealm $ClientRealm -User $AdminCred -DisableCertificateValidation

# Define Tenant User for WAP
Write-Output "$(Get-Date) - Defining tenant user for WAP for AD user $($ADUserSAM)." | Out-File -Append "c:\scripts\delete_tenant_user.log"
$WAPUser = Get-ADUser $ADUserSAM

# Delete Tenant User and Subscription in WAP
Write-Output "$(Get-Date) - Deleting tenant user and subscription in WAP for AD user $($ADUserSAM)." | Out-File -Append "c:\scripts\delete_tenant_user.log"
Remove-MgmtSvcUser -Name $WAPUser.UserPrincipalName -AdminUri $AdminURI -Token $Token -DeleteSubscriptions -DisableCertificateValidation -Confirm:$false

# Delete Tenant User in Active Directory
Write-Output "$(Get-Date) - Deleting tenant user $($ADUserSAM) in Active Directory." | Out-File -Append "c:\scripts\delete_tenant_user.log"
Remove-ADUser -Identity $ADUserSAM -Credential $AdminCred -Confirm:$false

# Exit Script
Write-Output "$(Get-Date) - Exiting script.`r`n" | Out-File -Append "c:\scripts\delete_tenant_user.log"
Exit
