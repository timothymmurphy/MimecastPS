<#
    .SYNOPSIS
    Creates new group in Mimecast
    Official Mimecast documentation: https://www.mimecast.com/tech-connect/documentation/endpoint-reference/directory/create-group/

    .PARAMETER Name
    The name of the group to be created

    .PARAMETER ParentID
    ID value of parent group (if creating a nested group is desired)

#>

function New-MimecastGroup {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [string]$ParentID
    )

    $jsonBody = "{
        ""data"": [
            {
                ""description"": ""$Name""
            }
        ]
    }"

    $psObjBody = $jsonBody |  ConvertFrom-Json    
    if ($ParentID) {$psObjBody.data | Add-Member -Name "parentId" -Value $ParentID -MemberType NoteProperty}
    $jsonBody = $psObjBody | ConvertTo-Json

    $Parameters = @{
        Uri           = "/api/directory/create-group"
        Method        = "Post"
        Body          = $jsonBody
    }

    $result = Invoke-MimecastMethod @Parameters

    $result
}