# MimecastPS
A PowerShell API wrapper for Mimecast.

# Setup
## PowerShell Gallery Installation
1. Open PowerShell and run `Install-Module -Name MimecastPS` to install the module from PowerShell Gallery
2. Open PowerShell and run `Import-Module MimecastPS` to import the module
3. Next run `Set-MimecastConfig` to create your `config.json` file with your appropriate API keys. After this has been generated, all of the commands in this module will work.

    - Example: `Set-MimecastConfig -Url "https://xx-api.mimecast.com" -AccessKey "YOUR_ACCESS_KEY" -SecretKey "YOUR_SECRET_KEY" -AppID "YOUR_APP_ID" -AppKey "YOUR_APP_KEY"`
      - Note: URL varies based on location - see [here](https://www.mimecast.com/tech-connect/documentation/api-overview/global-base-urls/) for more details.

## Manual Installation
1. Extract `MimecastPS` folder contents to one of the following directories:
    - `C:\Users\$username\Documents\WindowsPowerShell\Modules\MimecastPS` (local user scoped installation)
    - `C:\Program Files\WindowsPowerShell\Modules\MimecastPS` (global system installation)
    
2. Open PowerShell and Run `Import-Module MimecastPS` to import the module  

3. Next run `Set-MimecastConfig` to create your `config.json` file with your appropriate API keys. After this has been generated, all of the commands in this module will work.

    - Example: `Set-MimecastConfig -Url "https://xx-api.mimecast.com" -AccessKey "YOUR_ACCESS_KEY" -SecretKey "YOUR_SECRET_KEY" -AppID "YOUR_APP_ID" -AppKey "YOUR_APP_KEY"`
      - Note: URL varies based on location - see [here](https://www.mimecast.com/tech-connect/documentation/api-overview/global-base-urls/) for more details.

# Commands
## Account
- Get-MimecastSupportInfo
- Get-MimecastProducts
- Get-MimecastNotifications
- Get-MimecastAccount
## Archive
- Search-MimecastArchive
- Get-MimecastMessagePart
- Get-MimecastMessageList
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
## Targeted Threat Protection URL Protect
- Get-MimecastManagedURL
- Get-MimecastDecodedURL
- New-MimecastManagedURL
- Remove-MimecastManagedURL
