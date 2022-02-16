<#
    .SYNOPSIS
    Retrieves list of groups from Mimecast. 
    Official Mimecast documentation: https://www.mimecast.com/tech-connect/documentation/endpoint-reference/directory/find-groups/

    .PARAMETER Search
    A string to query for

    .PARAMETER Source
    A group source to filter on, either "Cloud" or "LDAP"

    .PARAMETER PageSize
    The number of results to request.

    .PARAMETER PageToken
    The value of the 'next' or 'previous' fields from an earlier request.

    .EXAMPLE
    Get-MimecastGroup

    .EXAMPLE
    Get-MimecastGroup -Search "Querystring" -Source Cloud -PageSize 10

#>

function Get-MimecastGroup {
    param (
        [string]$Search,

        [ValidateSet("Cloud", "LDAP")]
        [string]$Source,

        [int]$PageSize,

        [string]$PageToken
    )

    $jsonBody = "{
        ""meta"": {
        },
        ""data"": [
            {
            }
        ]
    }"

    $psObjBody = $jsonBody |  ConvertFrom-Json    

    if ($PageToken -or $PageSize) {
        $psObjBody.meta | Add-Member -Name "pagination" -Value ([PSCustomObject]@{}) -MemberType NoteProperty

        if ($PageToken) {$psObjBody.meta.pagination | Add-Member -Name "pageToken" -Value $PageToken -MemberType NoteProperty}
        if ($PageSize) {$psObjBody.meta.pagination | Add-Member -Name "pageSize" -Value $PageSize -MemberType NoteProperty}
    }
    if ($Search) {$psObjBody.data | Add-Member -Name "query" -Value $Search -MemberType NoteProperty}
    if ($Source) {$psObjBody.data | Add-Member -Name "source" -Value $Source -MemberType NoteProperty}
    

    $jsonBody = $psObjBody | ConvertTo-Json

    $Parameters = @{
        Uri           = "/api/directory/find-groups"
        Method        = "Post"
        Body          = $jsonBody
    }

    $result = Invoke-MimecastMethod @Parameters

    $result.data.folders
}