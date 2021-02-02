<#
    .SYNOPSIS
    Gets Group Member Information in Mimecast
    Official Mimecast documentation: https://www.mimecast.com/tech-connect/documentation/endpoint-reference/directory/get-group-members/

    .PARAMETER ID
    The Group ID to retrieve membership information from

    .PARAMETER PageSize
    ID value of parent group (if moving group under a different parent group)

    .PARAMETER PageToken
    ID value of the group to be updated

    .EXAMPLE
    Get-MimecastGroupMember -ID $id

    .EXAMPLE
    Get-MimecastGroupMember -ID $id -PageSize 10

#>

function Get-MimecastGroupMember {
    param (
        [Parameter(Mandatory = $true)]
        [string]$ID,

        [int]$PageSize,

        [string]$PageToken
    )

    $jsonBody = "{
        ""meta"": {
        },
        ""data"": [
            {
                ""id"": ""$ID""
            }
        ]
    }"

    $psObjBody = $jsonBody |  ConvertFrom-Json    
    if ($PageToken -or $PageSize) {
        $psObjBody.meta | Add-Member -Name "pagination" -Value ([PSCustomObject]@{}) -MemberType NoteProperty

        if ($PageToken) {$psObjBody.meta.pagination | Add-Member -Name "pageToken" -Value $PageToken -MemberType NoteProperty}
        if ($PageSize) {$psObjBody.meta.pagination | Add-Member -Name "pageSize" -Value $PageSize -MemberType NoteProperty}
    }
    $jsonBody = $psObjBody | ConvertTo-Json

    $Parameters = @{
        Uri           = "/api/directory/get-group-members"
        Method        = "Post"
        Body          = $jsonBody
    }

    $result = Invoke-MimecastMethod @Parameters

    $result
}