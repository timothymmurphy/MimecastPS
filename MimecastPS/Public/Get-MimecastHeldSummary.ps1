<#
    .SYNOPSIS
    Gets Group Member Information in Mimecast
    Official Mimecast documentation: https://www.mimecast.com/tech-connect/documentation/endpoint-reference/message-queues/get-hold-summary-list/

    .EXAMPLE
    Get-MimecastHeldSummary

#>

function Get-MimecastHeldSummary {
    param ()

    $jsonBody = "{
        ""data"": []
    }"

    $Parameters = @{
        Uri           = "/api/gateway/get-hold-summary-list"
        Method        = "Post"
        Body          = $jsonBody
    }

    $result = Invoke-MimecastMethod @Parameters

    $result
}