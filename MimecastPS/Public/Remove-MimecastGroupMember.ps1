<#
    .SYNOPSIS
    Removes email address or domain from group in Mimecast
    Official Mimecast documentation: https://www.mimecast.com/tech-connect/documentation/endpoint-reference/directory/remove-group-member/

    .PARAMETER ID
    The ID of the Group to add to

    .PARAMETER Domain
    Domain to be removed from the group. Must use either Domain or EmailAddress.

    .PARAMETER EmailAddress
    Email address to be removed from the group. Must use either EmailAddress or Domain.

    .EXAMPLE
    Remove-MimecastGroupMember -ID $id -Domain "example.com"

    .EXAMPLE
    Remove-MimecastGroupMember -ID $id -EmailAddress "email@example.com"

#>

function Remove-MimecastGroupMember {
    param (
        [Parameter(Mandatory = $true)]
        [string]$ID,

        [Parameter(ParameterSetName = 'Domain')]
        [string]$Domain,

        [Parameter(ParameterSetName = 'Email')]
        [string]$EmailAddress
    )

    $jsonBody = "{
        ""data"": [
            {
                ""id"": ""$ID"",
            }
        ]
    }"

    $psObjBody = $jsonBody |  ConvertFrom-Json    
    if ($Domain) {$psObjBody.data | Add-Member -Name "domain" -Value $Domain -MemberType NoteProperty}
    if ($EmailAddress) {$psObjBody.data | Add-Member -Name "emailAddress" -Value $EmailAddress -MemberType NoteProperty}
    $jsonBody = $psObjBody | ConvertTo-Json

    $Parameters = @{
        Uri           = "/api/directory/remove-group-member"
        Method        = "Post"
        Body          = $jsonBody
    }

    $result = Invoke-MimecastMethod @Parameters

    $result
}