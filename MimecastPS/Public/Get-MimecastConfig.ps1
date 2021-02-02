#Credit to https://mattbobke.com/2018/11/12/building-a-powershell-module-part-3-json-config-files-are-awesome/ for inspiration
function Get-MimecastConfig {
    <#
        .SYNOPSIS
        Get Mimecast API configuration.

        .DESCRIPTION
        Get Mimecast API configuration.

        .EXAMPLE
        Get-MimecastConfig
    #>

    [CmdletBinding()]
    param()

    try {
        Write-Verbose -Message 'Getting content of config.json and returning as a PSCustomObject.'
        $config = Get-Content -Path "$PSScriptRoot\..\config.json" -ErrorAction 'Stop' | ConvertFrom-Json

        $config = [PSCustomObject] @{
            url       = $config.url;
            accessKey = $config.accessKey;
            secretKey = $config.secretKey;
            appID     = $config.appID;
            appKey    = $config.appKey;
        }

        return $config

    } 
    catch {
        throw "Unable to find existing configuration file. Use 'Set-MimecastConfig' to create one."
    }
}