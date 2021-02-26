<#
    .SYNOPSIS
    Retrieves Message Part from the Mimecast Archive. 
    Official Mimecast documentation: https://www.mimecast.com/tech-connect/documentation/endpoint-reference/archive/get-message-part/

    .PARAMETER Mailbox
    The email address to return the message for.

    .PARAMETER Context
    Defines which copy of the message part to return. Must be set to "Delivered" or "Received"
    Delivered: the copy of the message after being processed by Mimecast
    Received: the copy of the message that Mimecast originally received

    .PARAMETER ID
    The ID of the message part to return.
    
    .PARAMETER Type
    The message part to return. Must be set to "HTML", "PLAIN", "RFC822", or "TRANSMISSION_MESSAGE_BODY"

    .EXAMPLE
    Get-MimecastMessagePart -Mailbox "mailbox@example.com" -Context Delivered -ID $id -Type HTML
#>

function Get-MimecastMessagePart {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Mailbox,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Delivered", "Received")]
        [string]$Context,

        [Parameter(Mandatory = $true)]
        [string]$ID,

        [Parameter(Mandatory = $true)]
        [ValidateSet("HTML", "PLAIN", "RFC822", "TRANSMISSION_MESSAGE_BODY")]
        [string]$Type
    )

    $jsonBody = "{
        ""data"": [
            {
                ""mailbox"": ""$Mailbox"",
                ""context"": ""$Context"",
                ""id"": ""$ID"",
                ""type"": ""$Type""
            }
        ]
       }"

    $Parameters = @{
        Uri           = "/api/archive/get-message-part"
        Method        = "Post"
        Body          = $jsonBody
    }

    $result = Invoke-MimecastMethod @Parameters

    $result
}