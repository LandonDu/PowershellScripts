<#
.synopsis
Script will create transport rules and add inbound/outbound connectors to be used for Proofpoint.

.description
An array is created with all of the Proofpoint IP addresses. Two connectors and one transport rule are then added to use Proofpoint servers as a relay and whitelist Proofpoint IP addresses.
#>


#An array of the Proofpoint IP addresses to be whitelisted.
$IPArray = @('67.231.152.0/24','67.231.153.0/24','67.231.154.0/24','67.231.155.0/24','67.231.156.0/24','67.231.144.0/24','67.231.145.0/24','67.231.146.0/24','67.231.147.0/24','67.231.148.0/24','67.231.149.0/24','148.163.128.0/24','148.163.129.0/24','148.163.130.0/24','148.163.131.0/24','148.163.132.0/24','148.163.133.0/24','148.163.134.0/24','148.163.135.0/24','148.163.136.0/24','148.163.137.0/24','148.163.138.0/24','148.163.139.0/24','148.163.140.0/24','148.163.141.0/24','148.163.142.0/24','148.163.143.0/24','148.163.144.0/24','148.163.145.0/24','148.163.146.0/24','148.163.147.0/24','148.163.148.0/24','148.163.149.0/24','148.163.150.0/24','148.163.151.0/24','148.163.152.0/24','148.163.153.0/24','148.163.154.0/24','148.163.155.0/24','148.163.156.0/24','148.163.157.0/24','148.163.158.0/24','148.163.159.0/24')

Connect-exchangeonline

New-InboundConnector -Name "Proofpoint Essentials Inbound Connector" -Enabled $False -SenderDomains * -SenderIPAddresses $IPArray -RequireTLS $true

New-OutboundConnector -Name "Outbound connector for Proofpoint Essentials" -Enabled $False -SmartHosts 'outbound-us1.ppe-hosted.com' -RecipientDomains * -TlsSettings CertificateValidation -UseMXRecord $False

New-TransportRule -Name "Bypass Spam filtering for Proofpoint Essentials" -Enabled $False -SenderIpRanges $IPArray -SetSCL "-1"

#Error handling in Exchange Online doesn't work well. This checks to see if any errors were generated and saved to the default $error variable. If not, it will show that it completed successfully. 
If ($null -eq $error) {
    write-host "The inbound/outbound connectors and transport rules have been configured successfully."
} else {
    write-host "Please review the errors: $error"
}
Disconnect-ExchangeOnline