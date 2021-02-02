<#
    .SYNOPSIS
    Retrieves Mimecast account support information.
    Official Mimecast documentation: https://www.mimecast.com/tech-connect/documentation/endpoint-reference/account/get-support-info/

    .EXAMPLE
    Get-MimecastSupportInfo

#>

function Get-MimecastSupportInfo {
    param ()

    $jsonBody =  "{
        ""data"": [
        ]
    }"

    $Parameters = @{
        Uri           = "/api/account/get-support-info"
        Method        = "Post"
        Body          = $jsonBody
    }

    $result = Invoke-MimecastMethod @Parameters

    $result
}