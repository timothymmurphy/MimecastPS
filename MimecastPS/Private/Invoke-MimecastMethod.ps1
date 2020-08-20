function Invoke-MimecastMethod {
    <#
    .SYNOPSIS
    Invokation of the Mimecast API call
    #>
    [OutputType(
        [PSObject]
    )]
    param (
        [Parameter(Mandatory = $true)]
        [Uri]$Uri,

        [string]$Method = "POST",

        [ValidateNotNullorEmpty()]
        [string]$Body,

        [string]$accessKey,

        [string]$secretKey, 

        [string]$appId,

        [string]$appKey

        # # GET Parameters
        # [Hashtable]$GetParameters
    )

    BEGIN {
        #Generate request header values
        $hdrDate = (Get-Date).ToUniversalTime().ToString("ddd, dd MMM yyyy HH:mm:ss UTC")
        $requestId = [guid]::NewGuid().guid

        #Create the HMAC SHA1 of the Base64 decoded secret key for the Authorization header
        $sha = New-Object System.Security.Cryptography.HMACSHA1
        $sha.key = [Convert]::FromBase64String($secretKey)
        $sig = $sha.ComputeHash([Text.Encoding]::UTF8.GetBytes($hdrDate + ":" + $requestId + ":" + $uri + ":" + $appKey))
        $sig = [Convert]::ToBase64String($sig)

        #Create headers
        $headers = @{
            "Authorization" = "MC" + $accessKey + ":" + $sig
            "x-mc-date" = $hdrDate
            "x-mc-app-id" = $appId
            "x-mc-req-id" = $requestId
            "Content-Type" = "application/json"
        }

    }

    PROCESS {
        # Set mandatory parameters
        $splatParameters = @{
            Uri             = $Uri
            Method          = $Method
            Headers         = $headers
            UseBasicParsing = $true
            ErrorAction     = 'SilentlyContinue'
        }

        if ($Body) {$splatParameters["Body"] = [System.Text.Encoding]::UTF8.GetBytes($Body)}

        $script:PSDefaultParameterValues = $global:PSDefaultParameterValues

        Write-Debug $Body

        # Invoke the API
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Invoking method $Method to URI $Uri"
            Write-Debug "[$($MyInvocation.MyCommand.Name)] Invoke-RestMethod with: $($splatParameters | Out-String)"
            $webResponse = Invoke-RestMethod @splatParameters
        }
        catch {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Failed to get an answer from the server"
            $webResponse = $_.Exception.Response
        }

        Write-Debug "[$($MyInvocation.MyCommand.Name)] Executed WebRequest. Access $webResponse to see details"

        if ($webResponse) {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Status code: $($webResponse.StatusCode)"

            if ($webResponse.Content) {
                 Write-Verbose $webResponse.Content

                $response = ConvertFrom-Json -InputObject $webResponse.Content

                if ($response.status -eq "Bad Request") {
                    Write-Error $($response.messages | Out-String)
                }
                else {
                    $result = $response
                    if (($response) -and ($response | Get-Member -Name payload))
                    {
                        $result = $response.payload
                    }
                    elseif (($response) -and ($response | Get-Member -Name rows)) {
                        $result = $response.rows
                    }

                    $result
                }
            }
            elseif ($webResponse.StatusCode -eq "Unauthorized") {
                Write-Error "[$($MyInvocation.MyCommand.Name)] You are not Authorized to access the resource, check your token is correct"
            }
            else {
                # No content, although statusCode < 400
                # This could be wanted behavior of the API
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] No content was returned."
            }

        }
        else {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] No Web result object was returned. This is unusual!"
        }
    }

    END {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function ended"
    }
}