<#
    .SYNOPSIS
    Gets Held Message information in Mimecast
    Official Mimecast documentation: https://www.mimecast.com/tech-connect/documentation/endpoint-reference/targeted-threat-protection-url-protect/get-managed-url/

    .PARAMETER Value
    Specify the URL or Domain to filter results

    .PARAMETER ExactMatch
    If this switch is present, the "Value" parameter will act as an exact match value.

    .EXAMPLE
    Get-MimecastManagedURL -Value "phishingwebsite.com"

#>

function Get-MimecastManagedURL {
    param (

        [String]$Value,

        [Switch]$ExactMatch

    )

    $Parameters = @{
        Uri           = "/api/ttp/url/get-all-managed-urls"
        Method        = "Post"
    }


    if ($Value) {
        $jsonBody = "{
            ""data"": [
                {
                }
            ]
        }"
        $psObjBody = $jsonBody | ConvertFrom-Json

        $psObjBody.data | Add-Member -Name "domainOrUrl" -Value $Value -MemberType NoteProperty

        if ($ExactMatch) {
            $psObjBody.data | Add-Member -Name "exactMatch" -Value $true -MemberType NoteProperty
        } else {
            $psObjBody.data | Add-Member -Name "exactMatch" -Value $false -MemberType NoteProperty
        }

        $jsonBody = $psObjBody | ConvertTo-Json
        $Parameters.Add('Body', $jsonBody)
    }

    

    $result = Invoke-MimecastMethod @Parameters

    $result
}