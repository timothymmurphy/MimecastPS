<#
    .SYNOPSIS
    Decodes rewritten Mimecast URL
    Official Mimecast documentation: https://www.mimecast.com/tech-connect/documentation/endpoint-reference/targeted-threat-protection-url-protect/decode-url/

    .PARAMETER URL
    URL to be decoded

    .EXAMPLE
    Get-MimecastDecodedURL -URL "https://protect-us.mimecast.com/s/abcdefg"

#>

function Get-MimecastDecodedURL {
    param (
        
        [Parameter(Mandatory = $true)]
        [String]$URL

    )

    $jsonBody = "{
        ""data"": [
            {
                ""url"": ""$URL""
            }
        ]
    }"
    
    $Parameters = @{
        Uri           = "/api/ttp/url/decode-url"
        Method        = "Post"
        Body          = $jsonBody
    }

    $result = Invoke-MimecastMethod @Parameters

    $result
}