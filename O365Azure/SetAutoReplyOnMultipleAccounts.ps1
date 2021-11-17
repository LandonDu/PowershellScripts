[CmdletBinding()]
#Parameter values for internal/external message. Leave the value blank if nothing is needed. 
Param (
    [parameter(mandatory=$true)]
    [string]$FilePath,
    [string]$InternalMessage = '',
    [string]$ExternalMessage = ''
)
#Import the file that has a list of user email addresses.
Write-Verbose -message "Importing list of users." -Verbose 
$EmailAccounts = get-content -path $FilePath

#Connecting to Exchange online
$credential = get-credential -Message "Sign into the Exchange online account."
Connect-exchangeonline -credential $credential

#Set the out of office message for internal/external senders. This will send to all external senders. 
Write-Verbose -message "Setting out of office on each mailbox." -Verbose
ForEach ($User in $EmailAccounts) {
    Set-MailboxAutoReplyConfiguration -Identity $User -AutoReplyState Enabled -ExternalMessage $ExternalMessage -internalMessage $InternalMessage -ExternalAudience All
}

Disconnect-ExchangeOnline 

Write-Verbose -message "I hope my services proved useful." -Verbose