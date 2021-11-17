[cmdletbinding()]

param (
    [Parameter(Mandatory=$True)]
    $DisplayName,
    [Parameter(Mandatory=$True)]
    $Email
)

$credential = Get-Credential -Message "Enter your O365 admin credentials."

Connect-AzureAD -Credential $credential

New-AzureADMSInvitation -InvitedUserDisplayName $DisplayName -InvitedUserEmailAdress $Email -SendInvitationMessage $true