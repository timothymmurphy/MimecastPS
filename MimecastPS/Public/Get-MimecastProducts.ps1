<#
    .SYNOPSIS
    Retrieves Mimecast product information.
    Official Mimecast documentation: https://www.mimecast.com/tech-connect/documentation/endpoint-reference/account/get-products/

    Note: To use this endpoint the requesting user must be a member of the Partner Provisioning Role

    .EXAMPLE
    Get-MimecastProducts

#>

function Get-MimecastProducts {
    param ()

    $jsonBody =  "{
        ""data"": [
        ]
    }"

    $Parameters = @{
        Uri           = "/api/provisioning/get-packages"
        Method        = "Post"
        Body          = $jsonBody
    }

    $result = Invoke-MimecastMethod @Parameters

    $result
}