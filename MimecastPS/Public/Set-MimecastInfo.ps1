function Set-MimecastInfo {
    [CmdletBinding()]
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseShouldProcessForStateChangingFunctions', '')]
    param (
        [Uri]$baseUrl,
        [string]$accessKey,
        [string]$secretKey,
        [string]$appId,
        [string]$appKey
    )

    BEGIN {
        function Add-DefaultParameter {
            param (
                [Parameter(Mandatory = $true)]
                [string]$Command,
                
                [Parameter(Mandatory = $true)]
                [string]$Parameter,

                [Parameter(Mandatory = $true)]
                $Value

            )

            PROCESS {
                $PSDefaultParameterValues["${command}:${parameter}"] = $Value
                $global:PSDefaultParameterValues["${command}:${parameter}"] = $Value
            }
        }

        $moduleCommands = Get-Command -Module MimecastPS
    }

    PROCESS {
        foreach ($command in $moduleCommands) {
            $parameter = "baseUrl"
            if ($baseUrl -and ($command.Parameters.Keys -contains $parameter)) {
                Add-DefaultParameter -Command $command -Parameter -$parameter -Value ($baseUrl.AbsoluteUri.TrimEnd('/'))
            }

            $parameter = "accessKey"
            if ($accessKey -and ($command.Parameters.Keys -contains $parameter)) {
                Add-DefaultParameter -Command $command -Parameter $parameter -Value $accessKey
            }

            $parameter = "secretKey"
            if ($secretKey -and ($command.Parameters.Keys -contains $parameter)) {
                Add-DefaultParameter -Command $command -Parameter $parameter -Value $secretKey
            }

            $parameter = "appId"
            if ($appId -and ($command.Parameters.Keys -contains $parameter)) {
                Add-DefaultParameter -Command $command -Parameter $parameter -Value $appId
            }

            $parameter = "appKey"
            if ($appKey -and ($command.Parameters.Keys -contains $parameter)) {
                Add-DefaultParameter -Command $command -Parameter $parameter -Value $appKey
            }
        }
    }
}