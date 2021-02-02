<#
    .SYNOPSIS
    Retrieves notifications from the Mimecast administration console dashboard.
    Official Mimecast documentation: https://www.mimecast.com/tech-connect/documentation/endpoint-reference/account/get-dashboard-notifications/

    .EXAMPLE
    Get-MimecastNotifications

#>

function Get-MimecastNotifications {
    param ()

    $jsonBody =  "{
        ""data"": [
        ]
    }"

    $Parameters = @{
        Uri           = "/api/account/get-dashboard-notifications"
        Method        = "Post"
        Body          = $jsonBody
    }

    $result = Invoke-MimecastMethod @Parameters

    $result
}