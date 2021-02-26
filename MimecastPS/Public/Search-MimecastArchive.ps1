<#
    .SYNOPSIS
    Searches the Mimecast Archive. 
    Official Mimecast documentation: https://www.mimecast.com/tech-connect/documentation/endpoint-reference/archive/search/

    .PARAMETER Admin
    Level of results to return. If this switch is not present, only results for the currently authenticated user or their delegates will be returned. 
    If this switch is present, the entire archive will be searched.

    .PARAMETER Query
    The query string for the search. See this guide for more information on how to build search queries: https://www.mimecast.com/tech-connect/documentation/tutorials/building-search-queries/

    .PARAMETER PageToken
    The value of the 'next' or 'previous' fields from an earlier request.

    .EXAMPLE
    Search-MimecastArchive -Query "" -Admin
#>

function Search-MimecastArchive {
    param (
        [string]$Query,

        [switch]$Admin,

        [string]$PageToken
    )

    $jsonBody = "{
        ""meta"": {
        },
        ""data"":[
               {
                   ""query"": ""$Query""
               }
           ]
       }"

    $psObjBody = $jsonBody |  ConvertFrom-Json    

    if ($Admin) {
        $psObjBody.data | Add-Member -Name "admin" -Value $true -MemberType NoteProperty
    } else {
        $psObjBody.data | Add-Member -Name "admin" -Value $false -MemberType NoteProperty
    }    
    if ($PageToken) {
        $psObjBody.meta | Add-Member -Name "pagination" -Value ([PSCustomObject]@{}) -MemberType NoteProperty
        $psObjBody.meta.pagination | Add-Member -Name "pageToken" -Value $PageToken -MemberType NoteProperty
    }

    $jsonBody = $psObjBody | ConvertTo-Json

    $Parameters = @{
        Uri           = "/api/archive/search"
        Method        = "Post"
        Body          = $jsonBody
    }

    $result = Invoke-MimecastMethod @Parameters

    $result
}