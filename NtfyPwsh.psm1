<#
.SYNOPSIS
Builds an ntfy action header string.

.DESCRIPTION
This function constructs an ntfy action header string based on the provided parameters.

.PARAMETER Action
The type of action to perform. Valid values are 'view', 'http', 'broadcast'.

.PARAMETER Label
The label for the action.

.PARAMETER URL
The URL associated with the action.

.PARAMETER Clear
Optional switch to clear the action.

.PARAMETER Method
The HTTP method to use for 'http' actions. Valid values are 'GET', 'POST', 'PUT', 'DELETE'.

.PARAMETER Body
Optional body content for 'http' actions.

.PARAMETER Headers
Optional headers for 'http' actions.

.PARAMETER Intent
Optional intent for 'broadcast' actions.

.PARAMETER Extras
Optional extras for 'broadcast' actions.

.EXAMPLE
$actionHeader = Build-NtfyAction -Action 'view' -Label 'Open' -URL 'https://example.com'

.LINK
https://github.com/ptmorris1/NtfyPwsh
#>
function Build-NtfyAction {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet('view', 'http', 'broadcast')]
        [string]$Action,

        [Parameter(Mandatory = $true)]
        [string]$Label,

        [Parameter(Mandatory = $true)]
        [string]$URL,

        [Parameter(Mandatory = $false)]
        [switch]$Clear,

        [Parameter(Mandatory = $false)]
        [ValidateSet('GET', 'POST', 'PUT', 'DELETE')]
        [string]$Method,

        [Parameter(Mandatory = $false)]
        [string]$Body,

        [Parameter(Mandatory = $false)]
        [hashtable]$Headers,

        [Parameter(Mandatory = $false)]
        [string]$Intent,

        [Parameter(Mandatory = $false)]
        [hashtable]$Extras
    )

    $actionsHeader = ''

    if ($Action -eq 'view') {
        $actionsHeader = "$Action, $Label, $URL"
        if ($Clear) { $actionsHeader += ', clear=true' }
    } if ($Action -eq 'http') {
        $actionsHeader = "$Action, $Label, $URL, method=$Method"
        if ($Headers) {
            $simpleHeaders = ($Headers.GetEnumerator() | ForEach-Object { "headers.$($_.Key)=$($_.Value)" }) -join ', '
            $actionsHeader += ", $simpleHeaders"
        }
        if ($Body) { $actionsHeader += ", body=$Body" }
        if ($Clear) { $actionsHeader += ', clear=true' }
    } if ($Action -eq 'broadcast') {
        $actionsHeader = "$Action, $Label"
        if ($Intent) { $actionsHeader += ", intent=$Intent" }
        if ($Extras) {
            $simpleExtras = ($Extras | ForEach-Object { "extras.$($_.Key)=$($_.Value)" }) -join ', '
            $actionsHeader += ", $simpleExtras"
        }
        if ($Clear) { $actionsHeader += ', clear=true' }
    }

    return $actionsHeader
}

<#
.SYNOPSIS
Sends a message using ntfy.

.DESCRIPTION
This function sends a message to an ntfy topic with various optional parameters for customization.

.PARAMETER Title
The title of the message.

.PARAMETER Body
The body content of the message.

.PARAMETER URI
The base URI for the ntfy instance.

.PARAMETER Topic
The topic to which the message will be sent.

.PARAMETER TokenPlainText
Plain text token for authorization.

.PARAMETER TokenCreds
Credential object for authorization.

.PARAMETER Priority
The priority level of the message. Valid values are 'Max', 'High', 'Default', 'Low', 'Min'.

.PARAMETER Tags
Optional tags for the message.

.PARAMETER SkipCertCheck
Optional switch to skip certificate checks.

.PARAMETER Delay
Optional delay for the message.

.PARAMETER OnClick
Optional URL to open when the message is clicked.

.PARAMETER Action
Optional actions to include with the message.

.PARAMETER AttachmentPath
Optional path to a file to attach to the message.

.PARAMETER AttachmentName
Optional name for the attached file.

.PARAMETER AttachmentURL
Optional URL to an attachment.

.PARAMETER Icon
Optional icon for the message.

.PARAMETER Email
Optional email address for the message.

.PARAMETER Phone
Optional phone number for the message.

.PARAMETER Credential
Credential object for authorization.

.EXAMPLE
Send-NtfyMessage -Topic 'mytopic' -Title 'Hello' -Body 'This is a test message'

.LINK
https://github.com/ptmorris1/NtfyPwsh
#>
function Send-NtfyMessage {
    [CmdletBinding(DefaultParameterSetName = 'default')]
    param (
        [string]$Title,

        [string]$Body,

        [string]$URI,

        [Parameter(Mandatory = $true, ParameterSetName = 'attachmentURL')]
        [Parameter(Mandatory = $true, ParameterSetName = 'attachment')]
        [Parameter(Mandatory = $true, ParameterSetName = 'user')]
        [Parameter(Mandatory = $true, ParameterSetName = 'token')]
        [Parameter(Mandatory = $true, ParameterSetName = 'tokenCreds')]
        [Parameter(Mandatory = $true, ParameterSetName = 'action')]
        [Parameter(Mandatory = $true, ParameterSetName = 'default')]
        [string]$Topic,

        [Parameter(Mandatory = $false, ParameterSetName = 'attachmentURL')]
        [Parameter(Mandatory = $false, ParameterSetName = 'attachment')]
        [Parameter(Mandatory = $false, ParameterSetName = 'user')]
        [Parameter(Mandatory = $true, ParameterSetName = 'token')]
        [Parameter(Mandatory = $false, ParameterSetName = 'tokenCreds')]
        [Parameter(Mandatory = $false, ParameterSetName = 'action')]
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        [string]$TokenPlainText,

        [Parameter(Mandatory = $false, ParameterSetName = 'attachmentURL')]
        [Parameter(Mandatory = $false, ParameterSetName = 'attachment')]
        [Parameter(Mandatory = $false, ParameterSetName = 'user')]
        [Parameter(Mandatory = $false, ParameterSetName = 'token')]
        [Parameter(Mandatory = $true, ParameterSetName = 'tokenCreds')]
        [Parameter(Mandatory = $false, ParameterSetName = 'action')]
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        [pscredential]$TokenCreds,

        [ValidateSet('Max', 'High', 'Default', 'Low', 'Min')]
        [string]$Priority,

        [ArgumentCompleter({
                $possibleValues = @('👍', '👎️', '🤦', '🥳', '⚠️', '⛔', '🎉', '️🚨', '🚫', '✔️', '🚩', '💿', '📢', '💀', '💻')
                return $possibleValues | ForEach-Object { $_ }
            })]
        [string[]]$Tags,

        [switch]$SkipCertCheck,

        [string]$Delay,

        [string]$OnClick,

        [Parameter(Mandatory = $false, ParameterSetName = 'attachmentURL')]
        [Parameter(Mandatory = $false, ParameterSetName = 'attachment')]
        [Parameter(Mandatory = $false, ParameterSetName = 'user')]
        [Parameter(Mandatory = $false, ParameterSetName = 'token')]
        [Parameter(Mandatory = $false, ParameterSetName = 'tokenCreds')]
        [Parameter(Mandatory = $true, ParameterSetName = 'action')]
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        [array]$Action,

        [Parameter(Mandatory = $false, ParameterSetName = 'attachmentURL')]
        [Parameter(Mandatory = $true, ParameterSetName = 'attachment')]
        [Parameter(Mandatory = $false, ParameterSetName = 'user')]
        [Parameter(Mandatory = $false, ParameterSetName = 'token')]
        [Parameter(Mandatory = $false, ParameterSetName = 'tokenCreds')]
        [Parameter(Mandatory = $false, ParameterSetName = 'action')]
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        [string]$AttachmentPath,

        [Parameter(Mandatory = $false, ParameterSetName = 'attachmentURL')]
        [Parameter(Mandatory = $true, ParameterSetName = 'attachment')]
        [Parameter(Mandatory = $false, ParameterSetName = 'user')]
        [Parameter(Mandatory = $false, ParameterSetName = 'token')]
        [Parameter(Mandatory = $false, ParameterSetName = 'tokenCreds')]
        [Parameter(Mandatory = $false, ParameterSetName = 'action')]
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        [string]$AttachmentName,

        [Parameter(Mandatory = $true, ParameterSetName = 'attachmentURL')]
        [Parameter(Mandatory = $false, ParameterSetName = 'attachment')]
        [Parameter(Mandatory = $false, ParameterSetName = 'user')]
        [Parameter(Mandatory = $false, ParameterSetName = 'token')]
        [Parameter(Mandatory = $false, ParameterSetName = 'tokenCreds')]
        [Parameter(Mandatory = $false, ParameterSetName = 'action')]
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        [string]$AttachmentURL,

        [string]$Icon,

        [string]$Email,

        [string]$Phone,

        [Parameter(Mandatory = $true, ParameterSetName = 'user')]
        [Parameter(Mandatory = $false, ParameterSetName = 'token')]
        [Parameter(Mandatory = $false, ParameterSetName = 'tokenCreds')]
        [Parameter(Mandatory = $false, ParameterSetName = 'action')]
        [Parameter(Mandatory = $false, ParameterSetName = 'attachment')]
        [Parameter(Mandatory = $false, ParameterSetName = 'attachmentURL')]
        [Parameter(Mandatory = $false, ParameterSetName = 'default')]
        [PSCredential]$Credential
    )

    process {
        $ntfyHeaders = @{}
        $FullURI = if ($URI) {
            if ($URI.EndsWith('/')) { $URI + $Topic } else { "$URI/$Topic" }
        } else { "https://ntfy.sh/$Topic" }

        if ($Topic -match '[\s\W]') {
            throw 'Invalid topic format. The topic should not contain spaces or special characters.'
        }

        if ($Phone) {
            if ($Phone -notmatch '^\+\d{1,3}\d{10}$') {
                throw "Invalid phone number format. Please use a '+' sign followed by the country code and the phone number, e.g., +12223334444."
            }
            $ntfyHeaders.Add('Call', $Phone)
        }

        if ($SkipCertCheck) {
            $PSDefaultParameterValues = @{'Invoke-RestMethod:SkipCertificateCheck' = $true }
        }

        if ($Credential) {
            $ntfyAuth = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($Credential.UserName + ':' + $Credential.GetNetworkCredential().Password))
            $ntfyHeaders.Add('Authorization', "Basic $ntfyAuth")
        }

        if ($TokenPlainText) {
            $ntfyHeaders.Add('Authorization', "Bearer $TokenPlainText")
        }

        if ($TokenCreds) {
            $pass = $TokenCreds.GetNetworkCredential().Password
            $ntfyHeaders.Add('Authorization', "Bearer $pass")
        }

        if ($Title) {
            $ntfyHeaders.Add('Title', $Title)
        }

        if ($Priority) {
            $priorityLevels = @{
                'Max'     = '5'
                'High'    = '4'
                'Default' = '3'
                'Low'     = '2'
                'Min'     = '1'
            }
            if ($priorityLevels.ContainsKey($Priority)) {
                $ntfyHeaders.Add('Priority', $priorityLevels[$Priority])
            }
        }

        if ($Tags) {
            $ntfyTags = ($Tags | ForEach-Object {
                switch ($_) {
                    '👍' { '+1' }
                    '👎️' { '-1' }
                    '🤦' { 'facepalm' }
                    '🥳' { 'partying_face' }
                    '⚠️' { 'warning' }
                    '⛔' { 'no_entry' }
                    '🎉' { 'tada' }
                    '🚨' { 'rotating_light' }
                    '🚫' { 'no_entry_sign' }
                    '✔️' { 'heavy_check_mark' }
                    '🚩' { 'triangular_flag_on_post' }
                    '💿' { 'cd' }
                    '📢' { 'loudspeaker' }
                    '💀' { 'skull' }
                    '💻' { 'computer' }
                    default { $_ }
                }
            }) -join ','
            $ntfyHeaders.Add('Tags', $ntfyTags)
        }

        if ($Delay) {
            $ntfyHeaders.Add('At', $Delay)
        }

        if ($Action) {
            $ntfyHeaders.Add('Actions', $action -join ';')
        }

        if ($OnClick) {
            $ntfyHeaders.Add('Click', "Click=$OnClick")
        }

        if ($AttachmentName) {
            $ntfyHeaders.Add('Filename', $AttachmentName)
        }

        if ($AttachmentURL) {
            $ntfyHeaders.Add('Attach', $AttachmentURL)
        }

        if ($Icon) {
            $ntfyHeaders.Add('Icon', $Icon)
        }

        if ($Email) {
            $ntfyHeaders.Add('Email', $Email)
        }

        $Request = @{
            Method  = 'POST'
            URI     = $FullURI
            Headers = $ntfyHeaders
            Body    = $Body
        }

        if ($AttachmentPath) {
            $Request['InFile'] = $AttachmentPath
            $Request.Remove('Body')
        }

        if ($AttachmentURL) {
            $Request.Remove('Body')
        }

        try {
            $response = Invoke-RestMethod @Request
            $response.time = Get-Date -UnixTimeSeconds $response.time
            $response.expires = Get-Date -UnixTimeSeconds $response.expires
        } catch {
            $NtfyError = $_.ErrorDetails.Message | ConvertFrom-Json -ErrorAction SilentlyContinue
            switch ($NtfyError.http) {
                400 { Write-Error 'Bad Request:'; Write-Output $Request; Write-Output "`nSee $($NtfyError.link)" }
                403 { Write-Error 'Need to use authentication for this instance or topic:'; Write-Output "$FullURI"; Write-Output "See $($NtfyError.link)" }
                404 { Write-Error "Topic not found: $Topic"; Write-Output "$FullURI"; Write-Output "See $($NtfyError.link)" }
                default { Write-Error 'An error occurred while sending the message.'; Write-Output $_.Exception.Message }
            }
        }
    }

    end {
        $response | Add-Member -Name 'URI' -Value $FullURI -MemberType NoteProperty
        return $response
        #$PSCmdlet.ParameterSetName
    }
}