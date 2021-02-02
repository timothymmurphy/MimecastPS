<#
    .SYNOPSIS
    Updates group information in Mimecast
    Official Mimecast documentation: https://www.mimecast.com/tech-connect/documentation/endpoint-reference/directory/update-group/

    .PARAMETER Name
    The name of the group to be created

    .PARAMETER ParentID
    ID value of parent group (if moving group under a different parent group)

    .PARAMETER ID
    ID value of the group to be updated

    .EXAMPLE
    Set-MimecastGroup -ID $id -Name "NewName" -ParentID $parentID

#>

function Set-MimecastGroup {
    param (
        [Parameter(Mandatory = $true)]
        [string]$ID,

        [string]$ParentID,

        [string]$Name
    )

    $jsonBody = "{
        ""data"": [
            {
                ""id"": ""$ID""
            }
        ]
    }"

    $psObjBody = $jsonBody |  ConvertFrom-Json    
    if ($ParentID) {$psObjBody.data | Add-Member -Name "parentId" -Value $ParentID -MemberType NoteProperty}
    if ($Name) {$psObjBody.data | Add-Member -Name "description" -Value $Name -MemberType NoteProperty}
    $jsonBody = $psObjBody | ConvertTo-Json

    $Parameters = @{
        Uri           = "/api/directory/update-group"
        Method        = "Post"
        Body          = $jsonBody
    }

    $result = Invoke-MimecastMethod @Parameters

    $result
}