#Connects to Exchange Online and prompts for credentials/MFA.
Connect-ExchangeOnline

#Clears the constant error variable when the script starts.
$error.clear()

#Asks a user if they would like to block emails or domains.
$UserInput = Read-Host 'Would you like to block a domain or email?'

#If statement for entering the domains/emails to block and then blocking them. 
IF ($UserInput -like '*Domain*') {
    $UserInputDomains = Read-Host 'Enter the domains (Name or IP) you would like to block. Multiple entries can be separated by a space.'
    $DomainsToBlock = $userInputDomains.split(" ")
    set-hostedcontentfilterpolicy -identity default -blockedsenderdomains @{ADD=$DomainsToBlock}
    #If statement to make sure there were no errors.
    IF ($Error) {
        Write-Host "There was an error and no domains were blocked. Please try again."
    } Else {
        Write-Host "The following domains have been added to the block list: $($DomainsToBlock)"
    }

} elseif ($UserInput -like '*email*') {
    $UserInputEmails = Read-Host 'Enter the email address you would like to block. Multiple entries can be separated by a space.'
    $EmailsToBlock = $UserInputEmails.Split(" ")
    set-hostedcontentfilterpolicy -identity default -BlockedSenders @{ADD=$EmailsToBlock}
    #If statement to make sure there are no errors.
    IF ($Error) {
        Write-Host "There was an error and no email addresses were blocked. Please try again."
    } Else {
        Write-Host "The following emails have been blocked: $($EmailsToBlock)"
    }

} Else {
    Write-Host "Nothing has been added to the block list. Please try again."
}

#Disconnects the Exchange Online session once completed. 
Disconnect-ExchangeOnline -confirm:$false