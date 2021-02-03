<#
    .SYNOPSIS
    Creates a new Managed URL in Mimecast
    Official Mimecast documentation: https://www.mimecast.com/tech-connect/documentation/endpoint-reference/targeted-threat-protection-url-protect/create-managed-url/

    .PARAMETER URL
    URL to block or permit

    .PARAMETER Action
    Set to "block" to blacklist the URL, or set to "permit" to whitelist it.

    .PARAMETER MatchType
    Set to "explicit" to block or permit only instances of this full URL.
    Set to "domain" to block or permit any URL with the same domain.

    .PARAMETER DisableRewrite
    If this switch is present, this will disable rewriting of this URL in emails. Action must be set to "permit"

    .PARAMETER Comment
    Comment regarding why the URL is managed for tracking purposes

    .PARAMETER DisableUserAwareness
    Disable User Awareness challenges for this URL. Action must be set to "permit"

    .PARAMETER DisableLogging
    Disable logging of user clicks on the URL

    .EXAMPLE
    New-MimecastManagedURL -URL "https://phishingwebsite.com" -Action Block -MatchType Domain -Comment "Phishing Website"

#>

function New-MimecastManagedURL {
    param (
        
        [Parameter(Mandatory = $true)]
        [String]$URL,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Block", "Permit")]
        [String]$Action,

        [ValidateSet("Explicit", "Domain")]
        [String]$MatchType,

        [Switch]$DisableRewrite,

        [String]$Comment,

        [Switch]$DisableUserAwareness,

        [Switch]$DisableLogging

    )

    $jsonBody = "{
        ""data"": [
            {
                ""action"": ""$Action"",
                ""url"": ""$URL""
            }
        ]
    }"

    $psObjBody = $jsonBody | ConvertFrom-Json

    if ($MatchType) {$psObjBody.data | Add-Member -Name "matchType" -Value $MatchType -MemberType NoteProperty} 
    if ($DisableRewrite) {
        $psObjBody.data | Add-Member -Name "disableRewrite" -Value $true -MemberType NoteProperty
    } else {
        $psObjBody.data | Add-Member -Name "disableRewrite" -Value $false -MemberType NoteProperty
    }
    if ($Comment) {$psObjBody.data | Add-Member -Name "comment" -Value $Comment -MemberType NoteProperty}
    if ($DisableUserAwareness) {
        $psObjBody.data | Add-Member -Name "disableUserAwareness" -Value $true -MemberType NoteProperty
    } else {
        $psObjBody.data | Add-Member -Name "disableUserAwareness" -Value $false -MemberType NoteProperty
    }
    if ($DisableLogging) {
        $psObjBody.data | Add-Member -Name "disableLogClick" -Value $true -MemberType NoteProperty
    } else {
        $psObjBody.data | Add-Member -Name "disableLogClick" -Value $false -MemberType NoteProperty
    }

    $jsonBody = $psObjBody | ConvertTo-Json -Depth 4

    
    $Parameters = @{
        Uri           = "/api/ttp/url/create-managed-url"
        Method        = "Post"
        Body          = $jsonBody
    }

    $result = Invoke-MimecastMethod @Parameters

    $result
}