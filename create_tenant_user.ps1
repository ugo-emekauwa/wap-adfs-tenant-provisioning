# Create Tenant User in Windows Azure Pack Script v2, written by Ugo Emekauwa (uemekauw@cisco.com or uemekauwa@gmail.com)

# Start Script
Write-Output "`r`n$(Get-Date) - Starting 'Create Tenant User in Windows Azure Pack Script v2'." | Out-File -Append "c:\scripts\create_tenant_user.log"

# Import Required Modules for SCVMM and WAP
Write-Output "$(Get-Date) - Importing required modules for SCVMM and WAP." | Out-File -Append "c:\scripts\create_tenant_user.log"
Import-Module virtualmachinemanager
Import-Module virtualmachinemanagercore
Import-Module MgmtSvcAdmin

# Set Administrator Credentials for SCVMM and WAP
Write-Output "$(Get-Date) - Setting Administrator credentials for SCVMM and WAP." | Out-File -Append "c:\scripts\create_tenant_user.log"
$Admin = "domain\Administrator"
$Password = "Password" | ConvertTo-SecureString -AsPlainText -Force
$AdminCred = New-Object System.Management.Automation.PSCredential($Admin,$Password)

# Create User in Active Directory
Write-Output "$(Get-Date) - Creating user in Active Directory." | Out-File -Append "c:\scripts\create_tenant_user.log"
$ADUserFullName = "Gerald Lawson"
$ADUserJobTitle = "Electronic Engineer"
$ADUserGivenName = "Gerald"
$ADUserSurname = "Lawson"
$ADUserSAM = "glawson"
$ADUserUPN = "glawson@domain.org"
$ADUserEmail = "glawson@domain.org"
$ADUserPassword = "Password"
New-ADUser -Name $ADUserFullName -Title $ADUserJobTitle -GivenName $ADUserGivenName -Surname $ADUserSurname -SamAccountName $ADUserSAM -UserPrincipalName $ADUserUPN -EmailAddress $ADUserEmail -Path "CN=Users,DC=domain,DC=org" -AccountPassword(ConvertTo-SecureString $ADUserPassword -AsPlainText -Force) -Enabled $true

# Set WAP Environment Specific Variables
Write-Output "$(Get-Date) - Setting WAP environment specific variables." | Out-File -Append "c:\scripts\create_tenant_user.log"
$WAPServer = "wap1.domain.org"

# Establish Connection to WAP
Write-Output "$(Get-Date) - Establishing connection to $($WAPServer)." | Out-File -Append "c:\scripts\create_tenant_user.log"
$AdminURI = "https://" + $WAPServer + ":30004"
$AuthSite = "https://" + $WAPServer + ":30072"
$ClientRealm = "http://azureservices/AdminSite"
$Token = Get-MgmtSvcToken -Type Windows -AuthenticationSite $AuthSite -ClientRealm $ClientRealm -User $AdminCred -DisableCertificateValidation

# Set WAP Plan Variables
Write-Output "$(Get-Date) - Setting WAP plan variables for AD user $($ADUserSAM)." | Out-File -Append "c:\scripts\create_tenant_user.log"
$PlanID = "Sample_Plan_ID"
$SubFN = "Sample_Plan_ID_Friendly_Name"

# Define Tenant User for WAP
Write-Output "$(Get-Date) - Defining tenant user for WAP for AD user $($ADUserSAM)." | Out-File -Append "c:\scripts\create_tenant_user.log"
$WAPUser = Get-ADUser $ADUserSAM

# Create Tenant User in WAP
Write-Output "$(Get-Date) - Creating tenant user in WAP for AD user $($ADUserSAM)." | Out-File -Append "c:\scripts\create_tenant_user.log"
$NewWAPUser = Add-MgmtSvcUser -AdminUri $AdminURI -Token $Token -Name $WAPUser.UserPrincipalName -Email $WAPUser.UserPrincipalName -State 'Active'

# Subscribe Tenant User to WAP Plan
Write-Output "$(Get-Date) - Subscribing WAP tenant user $($ADUserSAM) to WAP plan $($SubFN)." | Out-File -Append "c:\scripts\create_tenant_user.log"
$NewWAPUserSub = Add-MgmtSvcSubscription -AdminUri $AdminURI -Token $Token -AccountAdminLiveEmailId $WAPUser.UserPrincipalName -AccountAdminLivePuid $WAPUser.UserPrincipalName -PlanId $PlanID -FriendlyName $SubFN -DisableCertificateValidation

# Set SCVMM Environment Specific Variables
Write-Output "$(Get-Date) - Setting SCVMM environment specific variables." | Out-File -Append "c:\scripts\create_tenant_user.log"
$SCVMMServer = "scvmm1.domain.org"

# Establish Connection to SCVMM
Write-Output "$(Get-Date) - Establishing connection to $($SCVMMServer)." | Out-File -Append "c:\scripts\create_tenant_user.log"
Get-SCVMMServer -ComputerName $SCVMMServer -Credential $AdminCred

# Determine SCVMM User Role Name for New WAP User
Write-Output "$(Get-Date) - Determining the SCVMM user role name for WAP tenant user $($ADUserSAM)." | Out-File -Append "c:\scripts\create_tenant_user.log"
$SCUserRoleName = "$($NewWAPUser.Email)_$($NewWAPUserSub.SubscriptionID)"

# Retrieve SCVMM User Role
Write-Output "$(Get-Date) - Retrieving the SCVMM user role named $($SCUserRoleName)." | Out-File -Append "c:\scripts\create_tenant_user.log"
$GetSCUserRole = Get-SCUserRole -Name $SCUserRoleName

# Add AD User to SCVMMM User Role
Write-Output "$(Get-Date) - Adding AD user $($ADUserSAM) to the SCVMM user role named $($SCUserRoleName)." | Out-File -Append "c:\scripts\create_tenant_user.log"
Set-SCUserRole -UserRole $GetSCUserRole -AddMember $ADUserSAM

# Exit Script
Write-Output "$(Get-Date) - Exiting script.`r`n" | Out-File -Append "c:\scripts\create_tenant_user.log"
Exit
