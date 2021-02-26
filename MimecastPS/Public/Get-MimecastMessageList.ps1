<#
    .SYNOPSIS
    Retrieves Message List from Mimecast Archive. 
    Official Mimecast documentation: https://www.mimecast.com/tech-connect/documentation/endpoint-reference/archive/get-message-list/

    .PARAMETER View
    The type of message list to return. Must be set to "Inbox" or "Sent"

    .PARAMETER Mailbox
    The email address to return the message list for. If excluded, messages for the logged in user are returned.

    .PARAMETER Start
    The start date of messages to return, in the following format, 2015-11-16T14:49:18+0000. Default is the last calendar month.
    
    .PARAMETER End
    The end date of messages to return, in the following format, 2015-11-16T14:49:18+0000. Default is the end of the current day.

    .PARAMETER IncludeDelegates
    If this switch is present, includes messages for addresses that the mailbox has delegate permissions to.
    
    .PARAMETER ExcludeAliases
    If this switch is present, excludes messages for alias addresses of the mailbox.

    .PARAMETER PageToken
    The value of the 'next' or 'previous' fields from an earlier request.

    .EXAMPLE
    Get-MimecastMessageList -View Inbox -Mailbox "mailbox@example.com" 
#>

function Get-MimecastMessageList {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet("Inbox", "Sent")]
        [string]$View,

        [string]$Mailbox,

        [Parameter(ParameterSetName="Date")]
        [DateTime]$Start,

        [Parameter(ParameterSetName="Date")]
        [DateTime]$End,

        [switch]$IncludeDelegates,

        [switch]$ExcludeAliases,

        [string]$PageToken 
    )

    $jsonBody = "{
        ""meta"": {
        },
        ""data"": [
            {
                ""view"": ""$View""
            }
        ]
       }"

    $psObjBody = $jsonBody |  ConvertFrom-Json    

    if ($PageToken) {
        $psObjBody.meta | Add-Member -Name "pagination" -Value ([PSCustomObject]@{}) -MemberType NoteProperty
        $psObjBody.meta.pagination | Add-Member -Name "pageToken" -Value $PageToken -MemberType NoteProperty
    }
    if ($ExcludeAliases) {
        $psObjBody.data | Add-Member -Name "includeAliases" -Value $false -MemberType NoteProperty
    } else {
        $psObjBody.data | Add-Member -Name "includeAliases" -Value $true -MemberType NoteProperty
    }
    if ($IncludeDelegates) {
        $psObjBody.data | Add-Member -Name "includeDelegates" -Value $true -MemberType NoteProperty
    } else {
        $psObjBody.data | Add-Member -Name "includeDelegates" -Value $false -MemberType NoteProperty
    }
    if ($Start -or $End) {
        $psObjBody.data | Add-Member -Name "start" -Value $Start -MemberType NoteProperty
        $psObjBody.data | Add-Member -Name "end" -Value $End -MemberType NoteProperty
    }
    id ($Mailbox) {$psObjBody.data | Add-Member -Name "mailbox" -Value $Mailbox -MemberType NoteProperty}

    $jsonBody = $psObjBody | ConvertTo-Json

    $Parameters = @{
        Uri           = "/api/archive/get-message-list"
        Method        = "Post"
        Body          = $jsonBody
    }

    $result = Invoke-MimecastMethod @Parameters

    $result
}