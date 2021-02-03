###### Actively being developed, expect frequent changes to this repository

# MimecastPS
A PowerShell wrapper for the Mimecast API.

# Setup
First run `Set-MimecastConfig` to create your `config.json` file with your appropriate API keys. After this has been generated, all of the commands in this module will work.

Example: 

`Set-MimecastConfig -Url "https://xx-api.mimecast.com" -AccessKey "YOUR_ACCESS_KEY" -SecretKey "YOUR_SECRET_KEY" -AppID "YOUR_APP_ID" -AppKey "YOUR_APP_KEY"`

Note: URL varies based on location - see [here](https://www.mimecast.com/tech-connect/documentation/api-overview/global-base-urls/) for more details.

# Commands
## Account
- Get-MimecastSupportInfo
- Get-MimecastProducts
- Get-MimecastNotifications
- Get-MimecastAccount
## Groups
- Get-MimecastGroup
- Get-MimecastGroupMember
- New-MimecastGroup
- New-MimecastGroupMember
- Set-MimecastGroup
- Remove-MimecastGroupMember
## Message Queues
- Get-MimecastHeldMessages
- Get-MimecastHeldSummary
