#Credit to https://mattbobke.com/2018/11/12/building-a-powershell-module-part-3-json-config-files-are-awesome/ for inspiration
function Set-MimecastConfig {
    <#
        .SYNOPSIS
        Set required values to make Mimecast API calls.

        .DESCRIPTION
        Sets the URL, Access Key, Secret Key, App ID, and App Key which are required to make any API calls.

        .PARAMETER Url
        Base URL, e.g. "https://xx-api.mimecast.com"
        See official Mimecast Global Base URLs page for guidance: https://www.mimecast.com/tech-connect/documentation/api-overview/global-base-urls/

        .PARAMETER AccessKey
        Access Key

        .PARAMETER SecretKey
        Secret Key

        .PARAMETER AppID
        App ID

        .PARAMETER AppKey
        App Key

        .EXAMPLE
        Set-MimecastConfig -Url "https://xx-api.mimecast.com" -AccessKey "accessKey" -SecretKey "secretKey" -AppID "appID" -AppKey "appKey"
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Url,
        
        [Parameter(Mandatory = $true)]
        [string]$AccessKey,
        
        [Parameter(Mandatory = $true)]
        [string]$SecretKey,
        
        [Parameter(Mandatory = $true)]
        [string]$AppId,

        [Parameter(Mandatory = $true)]
        [string]$AppKey
    )

    try {
        Write-Verbose -Message 'Checking for existing configuration...'
        $config = Get-Content -Path "$PSScriptRoot\..\config.json" -ErrorAction 'Stop' | ConvertFrom-Json
        Write-Verbose -Message 'Stored config.json found.'
    } 
    catch {
        Write-Verbose -Message 'No configuration found - starting with empty configuration.'
        $jsonString = @'
{   
    "url" : "",
    "accessKey" : "",
    "secretKey" : "",
    "appID" : "",
    "appKey" : ""
}
'@
        $config = $jsonString | ConvertFrom-Json
    }

    if ($Url) {$config.url = $Url}
    if ($AccessKey) {$config.accessKey = $AccessKey}
    if ($SecretKey) {$config.secretKey = $SecretKey}
    if ($AppId) {$config.appID = $AppId}
    if ($AppKey) {$config.appKey = $appKey}

    Write-Verbose -Message 'Setting config.json.'
    $config | ConvertTo-Json | Set-Content -Path "$PSScriptRoot\..\config.json"
}