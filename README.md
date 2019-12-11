# How-To: Automating Tenant User Account Provisioning for Windows Azure Pack Integrated with ADFS

The sample Microsoft Windows PowerShell scripts listed in this repository demonstrate how to automate creating and deleting user accounts for Windows Azure Pack (WAP) environments that are integrated with Active Directory Federation Services (ADFS).

## Creating Tenant User Accounts:
The sample PowerShell script named **create_tenant_user.ps1** demonstrates how to perform the following primary actions:
1. Create the user account in the local Active Directory.
2. Create the user account in Windows Azure Pack.
3. Subscribe the user account to a Windows Azure Pack service plan.

## Deleting Tenant User Accounts:
The sample PowerShell script named **delete_tenant_user.ps1** demonstrates how to perform the following primary actions:
1. Delete the user account and service plan subscription in Windows Azure Pack.
2. Delete any cloud resources and virtual machines created or owned by the user account in System Center Virtual Machine Manager (SCVMM) managing Microsoft Hyper-V.
3. Delete the user account in the local Active Directory.

## Requirements:
1. Microsoft Windows PowerShell.
2. Windows Azure Pack Scripts and Cmdlets for PowerShell, currently available at [http://go.microsoft.com/?linkid=9811175](http://go.microsoft.com/?linkid=9811175).
3. System Center Virtual Machine Manager (SCVMM) PowerShell cmdlets available by installing the SCVMM Console.
4. Active Directory Module for Windows PowerShell.

## Author:
Ugo Emekauwa

## Contact Information:
uemekauw@cisco.com or uemekauwa@gmail.com
