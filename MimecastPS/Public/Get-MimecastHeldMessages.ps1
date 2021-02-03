<#
    .SYNOPSIS
    Gets Held Message information in Mimecast
    Official Mimecast documentation: https://www.mimecast.com/tech-connect/documentation/endpoint-reference/message-queues/get-hold-message-list/

    .PARAMETER Admin
    Level of results to return. If this switch is not present, only results for the currently authenticated user will be returned. 
    If this switch is present, held messages for all recipients will be returned.

    .PARAMETER Start
    Date and time of the earliest message to return

    .PARAMETER End
    Date and time of the latest message to return

    .PARAMETER Search
    Query to filter results

    .PARAMETER SearchField
    Fields to query based on. Permitted values include: "All", "Subject", "Sender", "Recipient", "ReasonCode"

    .PARAMETER MessageRoute
    Specify route of emails to return. Permitted values include: "All", "Internal", "Outbound", "Inbound", "External"

    .PARAMETER HeldGroup
    Specify the level of hold placed on messages to return. Permitted values include: "Admin", "Moderator", "User", "Cluster"

    .PARAMETER Attachments
    Specify if results should be held attachments. If this switch is not present, messages will show regardless of attachment
    If this switch is present, only held attachments will be retrieved.

    .EXAMPLE
    Get-MimecastHeldMessages -Admin -Search "Password Reset Confirmation" -SearchField Subject -MessageRoute Inbound

#>

function Get-MimecastHeldMessages {
    param (

        [Switch]$Admin,

        [Parameter(ParameterSetName="Date")]
        [DateTime]$Start,

        [Parameter(ParameterSetName="Date")]
        [DateTime]$End,

        [String]$Search, 

        [ValidateSet("All", "Subject", "Sender", "Recipient", "Reason_Code")]
        [String]$SearchField,

        [ValidateSet("All", "Internal", "Outbound", "Inbound", "External")]
        [String]$MessageRoute,

        [ValidateSet("Administrator", "Moderator", "User", "Cluster")]
        [String]$HeldGroup,

        [Switch]$Attachments

    )

    $jsonBody = "{
        ""data"": [
            {
            }
        ]
    }"

    $psObjBody = $jsonBody | ConvertFrom-Json

    if ($Admin) {
        $psObjBody.data | Add-Member -Name "admin" -Value $true -MemberType NoteProperty
    } else {
        $psObjBody.data | Add-Member -Name "admin" -Value $false -MemberType NoteProperty
    }
    if ($Start -or $End) {
        $psObjBody.data | Add-Member -Name "start" -Value $Start -MemberType NoteProperty
        $psObjBody.data | Add-Member -Name "end" -Value $End -MemberType NoteProperty
    }
    if ($Search -or $SearchField) {
        $psObjBody.data | Add-Member -Name "searchBy" -Value @([PSCustomObject]@{}) -MemberType NoteProperty

        if ($Search) {$psObjBody.data.searchBy | Add-Member -Name "value" -Value "$Search" -MemberType NoteProperty}
        if ($SearchField) {$psObjBody.data.searchBy | Add-Member -Name "fieldName" -Value "$SearchField" -MemberType NoteProperty}
    }
    if ($MessageRoute -or $HeldGroup -or $Attachments) {
        $psObjBody.data | Add-Member -Name "filterBy" -Value @([PSCustomObject]@{}) -MemberType NoteProperty

        if ($MessageRoute) {$psObjBody.data.filterBy | Add-Member -Name "route" -Value $MessageRoute -MemberType NoteProperty}
        if ($HeldGroup) {$psObjBody.data.filterBy | Add-Member -Name "heldGroup" -Value $HeldGroup -MemberType NoteProperty}
        if ($Attachments) {$psObjBody.data.filterBy | Add-Member -Name "attachments" -Value "true" -MemberType NoteProperty}
    }

    $jsonBody = $psObjBody | ConvertTo-Json

    $Parameters = @{
        Uri           = "/api/gateway/get-hold-message-list"
        Method        = "Post"
        Body          = $jsonBody
    }

    $result = Invoke-MimecastMethod @Parameters

    $result
}