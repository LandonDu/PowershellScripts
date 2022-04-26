import-module ActiveDirectory

#Creates a variable of the date 90 days ago
$90daysago = (get-date).AddDays(-90)
#Creates a variable for account groups that should be excluded
Write-host "Creating a list of excluded accounts."
$ExcludedAccounts = get-aduser -filter * -properties Name,LastLogonDate,Memberof | Where-object {($_.memberof -like '*admin*')}
$DisabledAccounts = @()

#Creates a varible with the AD accounts that have not signed in in 90 days and do not have an admin count of 1 (An admin count of 1 is given to an account that was a member of an admin group).
Write-host "Creating a list of accounts that have not signed in in 90 days."
$OldAccounts = get-aduser -filter * -properties Name,LastLogonDate,MemberOf | where-object {($_.lastlogondate -lt $90daysago) -and ($_.Name -ne $excludedaccounts.name)}

#Disables each of the accounts and adds it to the $DisabledAccounts variable
Write-host "Disabling old accounts and creating a list of the accounts"
foreach ($account in $oldaccounts) {
    Disable-AdAccount -identity $account;
    $DisabledAccounts += [PSCustomObject]@{
        Name = $account.Name
        LastLogonData = $account.lastlogondate
    }
}

#Outputs the disabled accounts to a txt file at C:\radius180\disabledaccounts.txt
$disabledAccounts | Sort-object LastLogonDate -desc | format-table | out-file C:\radius180\disabledaccounts.txt