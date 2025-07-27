function Send-NtfyMessage {
    <#
    .SYNOPSIS
    Sends a message to an ntfy topic with optional customization and authentication.

    .DESCRIPTION
    Sends a message to an ntfy topic using the ntfy REST API. Supports custom title, body, priority, tags, actions, attachments (local file or URL), icons, email, phone, delayed/scheduled delivery, click actions, markdown formatting, no-cache, disable Firebase forwarding, and more. Allows for authentication using either Basic (username/password) or Bearer (API token) methods. Can be used with public ntfy.sh or self-hosted ntfy instances. Supports PowerShell credential objects for authentication. Compatible with all ntfy features as of module version.

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
    Optional delay for the message (RFC3339 timestamp, duration string, or natural language).

    .PARAMETER OnClick
    Optional URL to open when the message is clicked.

    .PARAMETER Action
    Optional actions to include with the message. Use Build-NtfyAction to construct these. Supports up to 3 actions.

    .PARAMETER AttachmentPath
    Optional path to a file to attach to the message.

    .PARAMETER AttachmentName
    Optional name for the attached file.

    .PARAMETER AttachmentURL
    Optional URL to an attachment (remote file).

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

    .PARAMETER Markdown
    If specified, adds 'Content-Type' = 'text/markdown' to the headers.

    .PARAMETER FirebaseNo
    If specified, adds a header to prevent forwarding the message to Firebase (sets Firebase=no).

    .EXAMPLE
    Send-NtfyMessage -Topic 'ntfypwsh' -Title 'Hello' -Body 'This is a test message'

    .EXAMPLE
    $creds = Get-Credential -UserName api
    Send-NtfyMessage -Topic 'ntfypwsh' -Body 'With Bearer token' -TokenCreds $creds

    .EXAMPLE
    $creds = Get-Credential -UserName user
    Send-NtfyMessage -Topic 'ntfypwsh' -Body 'With Basic Auth' -Credential $creds

    .EXAMPLE
    Send-NtfyMessage -Topic 'ntfypwsh' -Body 'With attachment' -AttachmentPath 'C:\temp\file.txt'

    .EXAMPLE
    Send-NtfyMessage -Topic 'ntfypwsh' -Body 'With attachment from URL' -AttachmentURL 'https://example.com/file.txt'

    .EXAMPLE
    Send-NtfyMessage -Topic 'ntfypwsh' -Body 'With icon' -Icon 'https://example.com/icon.png'

    .EXAMPLE
    Send-NtfyMessage -Topic 'ntfypwsh' -Body 'With click action' -OnClick 'https://example.com'

    .EXAMPLE
    Send-NtfyMessage -Topic 'ntfypwsh' -Body 'With scheduled delivery' -Delay '10m'

    .EXAMPLE
    Send-NtfyMessage -Topic 'ntfypwsh' -Body 'With markdown' -Markdown

    .EXAMPLE
    Send-NtfyMessage -Topic 'ntfypwsh' -Body "This message won't be stored server-side" -NoCache

    .EXAMPLE
    Send-NtfyMessage -Topic 'ntfypwsh' -Body "This message won't be forwarded to FCM" -FirebaseNo

    .OUTPUTS
    System.Object. Returns the ntfy response object, or $null if the request failed.

    .NOTES
    See https://docs.ntfy.sh/publish/ for more details on ntfy message options.
    Project: https://github.com/ptmorris1/NtfyPwsh

    .LINK
    https://ptmorris1.github.io/posts/NtfyPwsh-Examples/#-send-ntfymessage-cmdlet-overview
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
        [switch]$NoCache,
        [Parameter(ParameterSetName = 'Credential')]
        [Parameter(ParameterSetName = 'TokenCreds')]
        [Parameter(ParameterSetName = 'Anonymous')]
        [switch]$Markdown,
        [Parameter(Mandatory = $false, ParameterSetName = 'Credential')]
        [Parameter(Mandatory = $false, ParameterSetName = 'TokenCreds')]
        [Parameter(Mandatory = $false, ParameterSetName = 'Anonymous')]
        [switch]$FirebaseNo
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
            $ntfyHeaders.Add('Click', "$OnClick")
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

        if ($FirebaseNo) {
            $ntfyHeaders['Firebase'] = 'no'
        }

        if ($Markdown) {
            $ntfyHeaders['Content-Type'] = 'text/markdown'
        }

        # Debug: Output headers before sending
        Write-Verbose "ntfyHeaders: $($ntfyHeaders | Out-String)"

        $Request = @{
            Method  = 'POST'
            URI     = $FullURI
            Headers = $ntfyHeaders
            Body    = $Body
        }

        Write-Verbose "Request: $($Request | Out-String)"

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