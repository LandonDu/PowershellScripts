#Used for pulling all licensed O365 accounts in a tenant. It can be commonly used to pull accounts when Dave/Kim need to quote SAAS protect.

#Requires -RunAsAdministrator

[CmdletBinding()]

#Parameter for the file path the file is exported to.
Param ( 
    [parameter(mandatory=$true)]
    $FilePath = ''
)

#If statement to check and see if the file path exists. If not, it is created.
If ($FilePath -like "") {
    $FilePath = Read-Host "Please enter a valid location for this file to be exported to."
} If (!(test-path -Path $FilePath)) {
    New-Item -Path $FilePath -ItemType Directory -Force
}

#Try/catch statement to see if the MsOnline Module is installed. If not, it is installed.
Try {
    Connect-MSOLService
} catch {
    Write-Host 'MSOnline Module has not been installed. Installing now. '
    Install-Module -Name MSOnline -repository PSGallery -Force
    Connect-MsolService
}

$ExportedUsers = Get-MsolUser | Where-Object {$_.isLicensed -eq $true} | Select-Object @{n='Name';e={$_.DisplayName}},@{n='Email Address';e={$_.UserPrincipalName}} | Format-Table -autosize

$ExportedUsers | Out-File $FilePath\O365LicensedAccounts.csv

Write-Host "Completed exporting the list of licensed user accounts to $FilePath\O365LicensedAccounts.csv"