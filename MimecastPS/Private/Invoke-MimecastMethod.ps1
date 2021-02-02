function Invoke-MimecastMethod {
    <#
    .SYNOPSIS
    Invocation of the Mimecast API call
    #>
    
    param (
        [Parameter(Mandatory = $true)]
        [Uri]$Uri,

        [string]$Method = "Post",

        [string]$Body
    )
    
    #Retrieve Configuration Values
    $config = Get-MimecastConfig
    $accessKey     = $config.accessKey
    $secretKey     = $config.secretKey
    $appId         = $config.appID
    $appKey        = $config.appKey
    $baseUrl       = $config.url
    $targetUrl     = $baseUrl + $Uri

    #Generate request header values
    $hdrDate = (Get-Date).ToUniversalTime().ToString("ddd, dd MMM yyyy HH:mm:ss UTC")
    $requestId = [guid]::NewGuid().guid

    #Create the HMAC SHA1 of the Base64 decoded secret key for the Authorization header
    $sha = New-Object System.Security.Cryptography.HMACSHA1
    $sha.key = [Convert]::FromBase64String($secretKey)
    $sig = $sha.ComputeHash([Text.Encoding]::UTF8.GetBytes($hdrDate + ":" + $requestId + ":" + $Uri + ":" + $appKey))
    $sig = [Convert]::ToBase64String($sig)

    # Create headers
    $headers = @{
        "Authorization" = "MC " + $accessKey + ":" + $sig
        "x-mc-date" = $hdrDate
        "x-mc-app-id" = $appId
        "x-mc-req-id" = $requestId
        "Content-Type" = "application/json"
    }


    # Set mandatory parameters
    $splatParameters = @{
        Uri             = $targetUrl
        Method          = $Method
        Headers         = $headers
        Body            = $Body
    }

    # Invoke the API
    try {
        $webResponse = Invoke-RestMethod @splatParameters
    }
    catch {
        throw "Error: Bad response received."
    }

    if ($webResponse) {
        return $webResponse
    }
    
}
    