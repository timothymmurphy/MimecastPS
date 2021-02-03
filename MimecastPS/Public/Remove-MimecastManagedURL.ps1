<#
    .SYNOPSIS
    Removes an existing Managed URL entry in Mimecast
    Official Mimecast documentation: https://www.mimecast.com/tech-connect/documentation/endpoint-reference/targeted-threat-protection-url-protect/delete-managed-url/

    .PARAMETER ID
    ID of Managed URL to remove

    .EXAMPLE
    Remove-MimecastManagedURL -ID $id

#>

function Remove-MimecastManagedURL {
    param (
        
        [Parameter(Mandatory = $true)]
        [String]$ID

    )

    $jsonBody = "{
        ""data"": [
            {
                ""id"": ""$ID""
            }
        ]
    }"
    
    $Parameters = @{
        Uri           = "/api/ttp/url/delete-managed-url"
        Method        = "Post"
        Body          = $jsonBody
    }

    $result = Invoke-MimecastMethod @Parameters

    $result
}