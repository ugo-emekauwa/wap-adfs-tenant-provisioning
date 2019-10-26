# Create Tenant User in Windows Azure Pack (WAP) Script, written by Ugo Emekauwa (uemekauw@cisco.com or uemekauwa@gmail.com)

# Import Required Modules for WAP
Import-Module MgmtSvcAdmin

# Set Administrator Credentials for Active Directory and WAP
$Admin = "domain\Administrator"
$Password = "Password" | ConvertTo-SecureString -AsPlainText -Force
$AdminCred = New-Object System.Management.Automation.PSCredential($Admin,$Password)

# Create User in Active Directory
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
$WAPServer = "wap1.domain.org"

# Establish Connection to WAP
$AdminURI = "https://" + $WAPServer + ":30004"
$AuthSite = "https://" + $WAPServer + ":30072"
$ClientRealm = "http://azureservices/AdminSite"
$Token = Get-MgmtSvcToken -Type Windows -AuthenticationSite $AuthSite -ClientRealm $ClientRealm -User $AdminCred -DisableCertificateValidation

# Set WAP Plan Variables
$PlanID = "Sample_Plan_ID"
$SubFN = "Sample_Plan_ID_Friendly_Name"

# Define Tenant User for WAP
$WAPUser = Get-ADUser $ADUserSAM

# Create Tenant User in WAP
Add-MgmtSvcUser -AdminUri $AdminURI -Token $Token -Name $WAPUser.UserPrincipalName -Email $WAPUser.UserPrincipalName -State 'Active'

# Subscribe Tenant User to WAP Plan
Add-MgmtSvcSubscription -AdminUri $AdminURI -Token $Token -AccountAdminLiveEmailId $WAPUser.UserPrincipalName -AccountAdminLivePuid $WAPUser.UserPrincipalName -PlanId $PlanID -FriendlyName $SubFN -DisableCertificateValidation

# Exit Script
Exit
