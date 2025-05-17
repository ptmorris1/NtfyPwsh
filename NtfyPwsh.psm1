function Build-NtfyAction {
    <#
    .SYNOPSIS
    Builds a properly formatted ntfy action header string for use with ntfy message actions.

    .DESCRIPTION
    Constructs an ntfy action header string based on the provided parameters. Supports 'view', 'http', and 'broadcast' actions, and allows for optional HTTP methods, headers, body, intent, and extras. This function is useful for building the Actions header for ntfy messages that require user interaction or automation.

    .PARAMETER Action
    The type of action to perform. Valid values are 'view', 'http', or 'broadcast'.

    .PARAMETER Label
    The label for the action button or link.

    .PARAMETER URL
    The URL associated with the action (required for 'view' and 'http').

    .PARAMETER Clear
    If specified, adds 'clear=true' to the action, which will clear the notification after the action is triggered.

    .PARAMETER Method
    The HTTP method for 'http' actions. Valid values: 'GET', 'POST', 'PUT', 'DELETE'.

    .PARAMETER Body
    Optional body content for 'http' actions.

    .PARAMETER Headers
    Optional hashtable of headers for 'http' actions. Each key-value pair will be added as a header.

    .PARAMETER Intent
    Optional intent for 'broadcast' actions (Android only).

    .PARAMETER Extras
    Optional hashtable of extras for 'broadcast' actions (Android only).

    .EXAMPLE
    Build-NtfyAction -Action 'view' -Label 'Open Website' -URL 'https://example.com'

    .EXAMPLE
    Build-NtfyAction -Action 'http' -Label 'Trigger API' -URL 'https://api.example.com/trigger' -Method 'POST' -Body '{"foo":"bar"}' -Headers @{ Authorization = 'Bearer token' }

    .EXAMPLE
    Build-NtfyAction -Action 'broadcast' -Label 'Custom Intent' -Intent 'com.example.ACTION' -Extras @{ key1 = 'value1' }

    .OUTPUTS
    System.String. Returns a formatted ntfy action header string.

    .NOTES
    See https://docs.ntfy.sh/publish/#actions for more details on ntfy actions.
    #>
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

function Send-NtfyMessage {
    <#
    .SYNOPSIS
    Sends a message to an ntfy topic with optional customization and authentication.

    .DESCRIPTION
    Sends a message to an ntfy topic using the ntfy REST API. Supports custom title, body, priority, tags, actions, attachments, icons, email, phone, and more. Allows for authentication using either Basic (username/password) or Bearer (API token) methods. Can be used with public ntfy.sh or self-hosted ntfy instances.

    .PARAMETER Title
    The title of the message (optional).

    .PARAMETER Body
    The body content of the message (optional).

    .PARAMETER URI
    The base URI for the ntfy instance. Defaults to https://ntfy.sh if not specified.

    .PARAMETER Topic
    The topic to which the message will be sent. Must not contain spaces or special characters.

    .PARAMETER Priority
    The priority level of the message. Valid values: 'Max', 'High', 'Default', 'Low', 'Min'.

    .PARAMETER Tags
    Optional tags for the message. Can be emoji or text. Some emoji are mapped to ntfy tag names.

    .PARAMETER SkipCertCheck
    If specified, skips certificate validation for self-signed SSL certificates (PowerShell 7+ only).

    .PARAMETER Delay
    Optional delay for the message (RFC3339 timestamp or duration string).

    .PARAMETER OnClick
    Optional URL to open when the message is clicked.

    .PARAMETER Action
    Optional actions to include with the message. Use Build-NtfyAction to construct these.

    .PARAMETER AttachmentPath
    Optional path to a file to attach to the message.

    .PARAMETER AttachmentName
    Optional name for the attached file.

    .PARAMETER AttachmentURL
    Optional URL to an attachment.

    .PARAMETER Icon
    Optional icon for the message (URL or emoji).

    .PARAMETER Email
    Optional email address for the message.

    .PARAMETER Phone
    Optional phone number for the message (must be in +<countrycode><number> format).

    .PARAMETER Credential
    PSCredential object for Basic authentication (mutually exclusive with TokenCreds).

    .PARAMETER TokenCreds
    PSCredential object for Bearer token authentication (mutually exclusive with Credential). Use the token as the password.

    .EXAMPLE
    Send-NtfyMessage -Topic 'mytopic' -Title 'Hello' -Body 'This is a test message'

    .EXAMPLE
    $creds = Get-Credential -UserName api
    Send-NtfyMessage -Topic 'mytopic' -Body 'With Bearer token' -TokenCreds $creds

    .EXAMPLE
    $creds = Get-Credential -UserName user
    Send-NtfyMessage -Topic 'mytopic' -Body 'With Basic Auth' -Credential $creds

    .EXAMPLE
    Send-NtfyMessage -Topic 'mytopic' -Body 'With attachment' -AttachmentPath 'C:\temp\file.txt'

    .OUTPUTS
    System.Object. Returns the ntfy response object, or $null if the request failed.

    .NOTES
    See https://docs.ntfy.sh/publish/ for more details on ntfy message options.
    #>
    [CmdletBinding(DefaultParameterSetName = 'default')]
    param (
        [string]$Title,
        [string]$Body,
        [string]$URI,
        [Parameter(Mandatory = $true)]
        [string]$Topic,
        [ValidateSet('Max', 'High', 'Default', 'Low', 'Min')]
        [string]$Priority,
        [ArgumentCompleter({
            param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
            $possibleValues = @('👍', '👎️', '🤦', '🥳', '⚠️', '⛔', '🎉', '️🚨', '🚫', '✔️', '🚩', '💿', '📢', '💀', '💻')
            $possibleValues | Where-Object { $_ -like "$wordToComplete*" }
        })]
        [string[]]$Tags,
        [switch]$SkipCertCheck,
        [string]$Delay,
        [string]$OnClick,
        [array]$Action,
        [string]$AttachmentPath,
        [string]$AttachmentName,
        [string]$AttachmentURL,
        [string]$Icon,
        [string]$Email,
        [string]$Phone,
        [Parameter(ParameterSetName = 'Credential')]
        [PSCredential]$Credential,
        [Parameter(ParameterSetName = 'TokenCreds')]
        [PSCredential]$TokenCreds
    )

    process {
        $ntfyHeaders = @{ }
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

        # Remove authentication info from headers, add to request instead
        if ($Credential) {
            $RequestAuth = @{ Authentication = 'Basic'; Credential = $Credential }
        } elseif ($TokenCreds) {
            $RequestAuth = @{ Authentication = 'Bearer'; Token = $TokenCreds.Password }
        } else {
            $RequestAuth = @{ }
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
                    '️🚨' { 'rotating_light' }
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
            $ntfyHeaders.Add('Actions', $Action -join ';')
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

        # Add authentication info to request if present
        foreach ($key in $RequestAuth.Keys) {
            $Request[$key] = $RequestAuth[$key]
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
        if ($null -ne $response) {
            $response | Add-Member -Name 'URI' -Value $FullURI -MemberType NoteProperty
            return $response
        } else {
            return $null
        }
    }
}