<#
    .SYNOPSIS
    Retrieves list of groups from Mimecast. 
    Official Mimecast documentation: https://www.mimecast.com/tech-connect/documentation/endpoint-reference/directory/find-groups/

    .PARAMETER Search
    A string to query for

    .PARAMETER Source
    A group source to filter on, either "Cloud" or "LDAP"
#>

function Get-MimecastGroups {
    param (
        [string]$Search,

        [ValidateSet("Cloud", "LDAP")]
        [string]$Source
    )
}