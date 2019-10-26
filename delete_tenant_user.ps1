# Delete Tenant User in Windows Azure Pack (WAP) Script, written by Ugo Emekauwa (uemekauw@cisco.com or uemekauwa@gmail.com)

# Import Required Modules for WAP and System Center Virtual Machine Manager (SCVMM)
Import-Module MgmtSvcAdmin
Import-Module virtualmachinemanager
Import-Module virtualmachinemanagercore

# Set Administrator Credentials for Active Directory, WAP and SCVMM
$Admin = "domain\Administrator"
$Password = "Password" | ConvertTo-SecureString -AsPlainText -Force
$AdminCred = New-Object System.Management.Automation.PSCredential($Admin,$Password)

# Identify Tenant User's Sam Account Name from Active Directory
$ADUserSAM = "sampleuser"

# Set WAP Environment Specific Variables
$WAPServer = "wap1.domain.org"

# Establish Connection to WAP
$AdminURI = "https://" + $WAPServer + ":30004"
$AuthSite = "https://" + $WAPServer + ":30072"
$ClientRealm = "http://azureservices/AdminSite"
$Token = Get-MgmtSvcToken -Type Windows -AuthenticationSite $AuthSite -ClientRealm $ClientRealm -User $AdminCred -DisableCertificateValidation

# Define Tenant User for WAP
$WAPUser = Get-ADUser $ADUserSAM

# Delete Tenant User and Subscription in WAP
Remove-MgmtSvcUser -Name $WAPUser.UserPrincipalName -AdminUri $AdminURI -Token $Token -DeleteSubscriptions -DisableCertificateValidation -Confirm:$false

# Establish Connection to SCVMM
Get-SCVMMServer -ComputerName scvmm1.domain.org -Credential $AdminCred

# Define Tenant User for SCVMM
$SCVMMUser = $ADUserSAM

# Delete Tenant User Resources in SCVMM
$User_Resources = Get-CloudResource | Where-Object Owner -Match $SCVMMUser
ForEach ($User_Resource in $User_Resources)
{ Remove-CloudResource -CloudResource $User_Resource }

# Delete Tenant User Owned VMs in SCVMM
$Owned_VMs = Get-SCVirtualMachine | Where-Object Owner -Match $SCVMMUser
ForEach ($Owned_VM in $Owned_VMs)
{ Stop-SCVirtualMachine -VM $Owned_VM -Force }
ForEach ($Owned_VM in $Owned_VMs)
{ Remove-SCVirtualMachine -VM $Owned_VM }

# Delete Tenant User in Active Directory
Remove-ADUser -Identity $ADUserSAM -Credential $AdminCred -Confirm:$false

# Exit Script
Exit
