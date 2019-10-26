# How-To: Automating Tenant User Account Provisioning in Windows Azure Pack Integrated with ADFS

The sample Microsoft Windows PowerShell scripts listed in this repository demonstrate how to automate creating and deleting user accounts in Windows Azure Pack (WAP) environments that are integrated with Active Directory Federation Services (ADFS).

## Creating Tenant User Accounts
The sample PowerShell script named **create_tenant_user.ps1** demonstrates how to perform the following primary actions:
1. Creates the user account in the local Active Directory.
2. Creates the user account in Windows Azure Pack.
3. Subscribes the tenant user account to a Windows Azure Pack service plan.

## Deleting Tenant User Accounts
The sample PowerShell script named **delete_tenant_user.ps1** demonstrates how to perform the following primary actions:
1. Deletes the user account and service plan subscription in Windows Azure Pack.
2. Deletes any cloud resources created or owned by the user account in System Center Virtual Machine Manager (SCVMM) (e.g. virtual machines, etc.).
3. Deletes the user account in the local Active Directory.

## Requirements:
1. Microsoft Windows PowerShell.
2. Windows Azure Pack Scripts and Cmdlets for PowerShell, currently available at [http://go.microsoft.com/?linkid=9811175](http://go.microsoft.com/?linkid=9811175).
3. System Center Virtual Machine Manager (SCVMM) Console.
4. Active Directory Module for Windows PowerShell.

## Author:
Ugo Emekauwa

## Contact Information:
uemekauw@cisco.com or uemekauwa@gmail.com
