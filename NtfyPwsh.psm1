function Build-NtfyAction {
    <#
    .SYNOPSIS
    Builds a properly formatted ntfy action header string for use with ntfy message actions.

    .DESCRIPTION
    Constructs an ntfy action header string based on the provided parameters. Supports 'view', 'http', and 'broadcast' actions, and allows for optional HTTP methods, headers, body, intent, and extras. This function is useful for building the Actions header for ntfy messages that require user interaction or automation.

    .PARAMETER ActionView
    Switch to specify 'view' action type.

    .PARAMETER ActionHttp
    Switch to specify 'http' action type.

    .PARAMETER ActionBroadcast
    Switch to specify 'broadcast' action type.

    .PARAMETER Label
    The label for the action button or link.

    .PARAMETER URL
    The URL associated with the action (required for 'view' and 'http').

    .PARAMETER Clear
    If specified, adds 'clear=true' to the action, which will clear the notification after the action is triggered.

    .PARAMETER Method
    The HTTP method for 'http' actions. Valid values: 'GET', 'POST', 'PUT', 'DELETE'. Defaults to 'POST'.

    .PARAMETER Body
    Optional body content for 'http' actions.

    .PARAMETER Headers
    Optional hashtable of headers for 'http' actions. Each key-value pair will be added as a header.

    .PARAMETER Intent
    Optional intent for 'broadcast' actions (Android only).

    .PARAMETER Extras
    Optional hashtable of extras for 'broadcast' actions (Android only).

    .EXAMPLE
    Build-NtfyAction -ActionView -Label 'Open Website' -URL 'https://example.com'

    .EXAMPLE
    Build-NtfyAction -ActionHttp -Label 'Trigger API' -URL 'https://api.example.com/trigger' -Method 'POST' -Body '{"foo":"bar"}' -Headers @{ Authorization = 'Bearer token' }

    .EXAMPLE
    Build-NtfyAction -ActionBroadcast -Label 'Custom Intent' -Intent 'io.heckel.ntfy.USER_ACTION' -Extras @{ key1 = 'value1' }

    .EXAMPLE
    # Example: Send broadcast action to take a screenshot
    $action = Build-NtfyAction -ActionBroadcast -Label 'Take Screenshot' -Extras @{ cmd = 'screenshot' }
    Send-NtfyMessage -Topic 'mytopic' -Body 'Please take a screenshot.' -Action $action

    .OUTPUTS
    System.String. Returns a formatted ntfy action header string.

    .NOTES
    See https://docs.ntfy.sh/publish/#actions for more details on ntfy actions.
    #>
    [CmdletBinding(DefaultParameterSetName = 'View')]
    param (
        # Action type for all sets (use a switch for each set)
        [Parameter(Mandatory = $true, ParameterSetName = 'View')]
        [switch]$ActionView,

        [Parameter(Mandatory = $true, ParameterSetName = 'Http')]
        [switch]$ActionHttp,

        [Parameter(Mandatory = $true, ParameterSetName = 'Broadcast')]
        [switch]$ActionBroadcast,

        # Label for all sets
        [Parameter(Mandatory = $true, ParameterSetName = 'View')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Http')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Broadcast')]
        [string]$Label,

        # URL only for View and Http
        [Parameter(Mandatory = $true, ParameterSetName = 'View')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Http')]
        [string]$URL,

        # Clear only for View
        [Parameter(Mandatory = $false, ParameterSetName = 'View')]
        [switch]$Clear,

        # Http action only
        [Parameter(Mandatory = $false, ParameterSetName = 'Http')]
        [ValidateSet('GET', 'POST', 'PUT', 'DELETE')]
        [string]$Method = 'POST',

        [Parameter(Mandatory = $false, ParameterSetName = 'Http')]
        [hashtable]$Headers,

        [Parameter(Mandatory = $false, ParameterSetName = 'Http')]
        [string]$Body,

        [Parameter(Mandatory = $false, ParameterSetName = 'Http')]
        [switch]$ClearHttp,

        # Broadcast action only
        [Parameter(Mandatory = $false, ParameterSetName = 'Broadcast')]
        [string]$Intent = 'io.heckel.ntfy.USER_ACTION',

        [Parameter(Mandatory = $false, ParameterSetName = 'Broadcast')]
        [hashtable]$Extras,

        [Parameter(Mandatory = $false, ParameterSetName = 'Broadcast')]
        [switch]$ClearBroadcast
    )

    # Map parameters for unified processing
    if ($ActionView) {
        $actionType = 'view'
        $label = $Label
        $url = $URL
        $clear = $Clear
    } elseif ($ActionHttp) {
        $actionType = 'http'
        $label = $Label
        $url = $URL
        $clear = $ClearHttp
    } elseif ($ActionBroadcast) {
        $actionType = 'broadcast'
        $label = $Label
        $clear = $ClearBroadcast
    }

    $actionsHeader = ''

    if ($actionType -eq 'view') {
        $actionsHeader = "$actionType, $label, $url"
        if ($clear) { $actionsHeader += ', clear=true' }
    } elseif ($actionType -eq 'http') {
        $actionsHeader = "$actionType, $label, $url, method=$Method"
        if ($Headers) {
            $simpleHeaders = ($Headers.GetEnumerator() | ForEach-Object { "headers.$($_.Key)=$($_.Value)" }) -join ', '
            $actionsHeader += ", $simpleHeaders"
        }
        if ($Body) { $actionsHeader += ", body=$Body" }
        if ($clear) { $actionsHeader += ', clear=true' }
    } elseif ($actionType -eq 'broadcast') {
        $actionsHeader = "$actionType, $label"
        if ($Intent) { $actionsHeader += ", intent=$Intent" }
        if ($Extras) {
            $simpleExtras = ($Extras.GetEnumerator() | ForEach-Object { "extras.$($_.Key)=$($_.Value)" }) -join ', '
            $actionsHeader += ", $simpleExtras"
        }
        if ($clear) { $actionsHeader += ', clear=true' }
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

    .PARAMETER NoCache
    If specified, adds a header to prevent the message from being cached server-side (sets Cache=no).

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

    .EXAMPLE
    Send-NtfyMessage -Topic 'mytopic' -Body "This message won't be stored server-side" -NoCache

    .OUTPUTS
    System.Object. Returns the ntfy response object, or $null if the request failed.

    .NOTES
    See https://docs.ntfy.sh/publish/ for more details on ntfy message options.
    #>
    [CmdletBinding(DefaultParameterSetName = 'Anonymous')]
    param (
        [Parameter(ParameterSetName = 'Credential')]
        [Parameter(ParameterSetName = 'TokenCreds')]
        [Parameter(ParameterSetName = 'Anonymous')]
        [string]$Title,
        [Parameter(ParameterSetName = 'Credential')]
        [Parameter(ParameterSetName = 'TokenCreds')]
        [Parameter(ParameterSetName = 'Anonymous')]
        [string]$Body,
        [Parameter(ParameterSetName = 'Credential')]
        [Parameter(ParameterSetName = 'TokenCreds')]
        [Parameter(ParameterSetName = 'Anonymous')]
        [string]$URI,
        [Parameter(Mandatory = $true, ParameterSetName = 'Credential')]
        [Parameter(Mandatory = $true, ParameterSetName = 'TokenCreds')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Anonymous')]
        [ValidatePattern('^[^\s\W]+$')]
        [string]$Topic,
        [Parameter(ParameterSetName = 'Credential')]
        [Parameter(ParameterSetName = 'TokenCreds')]
        [Parameter(ParameterSetName = 'Anonymous')]
        [ValidatePattern('^\+\d{1,3}\d{10}$')]
        [string]$Phone,
        [Parameter(ParameterSetName = 'Credential')]
        [Parameter(ParameterSetName = 'TokenCreds')]
        [Parameter(ParameterSetName = 'Anonymous')]
        [ValidateSet('Max', 'High', 'Default', 'Low', 'Min')]
        [string]$Priority,
        [Parameter(ParameterSetName = 'Credential')]
        [Parameter(ParameterSetName = 'TokenCreds')]
        [Parameter(ParameterSetName = 'Anonymous')]
        [ArgumentCompleter({
            param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
            $possibleValues = @('👍', '👎️', '🤦', '🥳', '⚠️', '⛔', '🎉', '️🚨', '🚫', '✔️', '🚩', '💿', '📢', '💀', '💻')
            $possibleValues | Where-Object { $_ -like "$wordToComplete*" }
        })]
        [string[]]$Tags,
        [Parameter(ParameterSetName = 'Credential')]
        [Parameter(ParameterSetName = 'TokenCreds')]
        [Parameter(ParameterSetName = 'Anonymous')]
        [switch]$SkipCertCheck,
        [Parameter(ParameterSetName = 'Credential')]
        [Parameter(ParameterSetName = 'TokenCreds')]
        [Parameter(ParameterSetName = 'Anonymous')]
        [string]$Delay,
        [Parameter(ParameterSetName = 'Credential')]
        [Parameter(ParameterSetName = 'TokenCreds')]
        [Parameter(ParameterSetName = 'Anonymous')]
        [string]$OnClick,
        [Parameter(ParameterSetName = 'Credential')]
        [Parameter(ParameterSetName = 'TokenCreds')]
        [Parameter(ParameterSetName = 'Anonymous')]
        [array]$Action,
        [Parameter(ParameterSetName = 'Credential')]
        [Parameter(ParameterSetName = 'TokenCreds')]
        [Parameter(ParameterSetName = 'Anonymous')]
        [string]$AttachmentPath,
        [Parameter(ParameterSetName = 'Credential')]
        [Parameter(ParameterSetName = 'TokenCreds')]
        [Parameter(ParameterSetName = 'Anonymous')]
        [string]$AttachmentName,
        [Parameter(ParameterSetName = 'Credential')]
        [Parameter(ParameterSetName = 'TokenCreds')]
        [Parameter(ParameterSetName = 'Anonymous')]
        [string]$AttachmentURL,
        [Parameter(ParameterSetName = 'Credential')]
        [Parameter(ParameterSetName = 'TokenCreds')]
        [Parameter(ParameterSetName = 'Anonymous')]
        [string]$Icon,
        [Parameter(ParameterSetName = 'Credential')]
        [Parameter(ParameterSetName = 'TokenCreds')]
        [Parameter(ParameterSetName = 'Anonymous')]
        [string]$Email,
        [Parameter(Mandatory = $false, ParameterSetName = 'Credential')]
        [Parameter(Mandatory = $false, ParameterSetName = 'Anonymous')]
        [PSCredential]$Credential,
        [Parameter(Mandatory = $false, ParameterSetName = 'TokenCreds')]
        [Parameter(Mandatory = $false, ParameterSetName = 'Anonymous')]
        [PSCredential]$TokenCreds,
        [Parameter(Mandatory = $false, ParameterSetName = 'Credential')]
        [Parameter(Mandatory = $false, ParameterSetName = 'TokenCreds')]
        [Parameter(Mandatory = $false, ParameterSetName = 'Anonymous')]
        [switch]$NoCache
    )

    process {
        $ntfyHeaders = @{ }
        $FullURI = if ($URI) {
            if ($URI.EndsWith('/')) { $URI + $Topic } else { "$URI/$Topic" }
        } else { "https://ntfy.sh/$Topic" }

        # Manual validation for $Topic and $Phone removed (handled by ValidatePattern)
        if ($Phone) {
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

        if ($NoCache) {
            $ntfyHeaders['Cache'] = 'no'
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
            if ($response.PSObject.Properties['time']) {
                $response.time = Get-Date -UnixTimeSeconds $response.time
            }
            if ($response.PSObject.Properties['expires']) {
                $response.expires = Get-Date -UnixTimeSeconds $response.expires
            }
        } catch {
            $NtfyError = $_.ErrorDetails.Message | ConvertFrom-Json -ErrorAction SilentlyContinue
            switch ($NtfyError.http) {
                400 { Write-Error 'Bad Request:'; Write-Output $Request; Write-Output "`nSee $($NtfyError.link)" }
                403 { Write-Error 'Need to use authentication for this instance or topic:'; Write-Output "$FullURI"; Write-Output "See $($NtfyError.link)" }
                404 { Write-Error "Topic not found: $Topic"; Write-Output "$FullURI"; Write-Output "See $($NtfyError.link)" }
                default { Write-Error 'An error occurred while sending the message.'; Write-Output $_.Exception.Message; Write-Output $ntfyHeaders }
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