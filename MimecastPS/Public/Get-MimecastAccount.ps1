<#
    .SYNOPSIS
    Retrieves Mimecast account information.
    Official Mimecast documentation: https://www.mimecast.com/tech-connect/documentation/endpoint-reference/account/get-account/

    .EXAMPLE
    Get-MimecastAccount

#>

function Get-MimecastAccount {
    param ()

    $jsonBody =  "{
        ""data"": [
        ]
    }"

    $Parameters = @{
        Uri           = "/api/account/get-account"
        Method        = "Post"
        Body          = $jsonBody
    }

    $result = Invoke-MimecastMethod @Parameters

    $result.data
}