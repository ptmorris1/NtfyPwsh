function Build-NtfyAction {
    <#
    .SYNOPSIS
    Builds a properly formatted ntfy action header string for use with ntfy message actions.

    .DESCRIPTION
    Constructs an ntfy action header string based on the provided parameters. Supports 'view', 'http', and 'broadcast' actions, and allows for optional HTTP methods, headers, body, intent, extras, and clear options. This function is useful for building the Actions header for ntfy messages that require user interaction or automation. Supports up to 3 actions per notification.

    .PARAMETER ActionView
    Indicates the 'view' action type (open website/app).

    .PARAMETER ActionHttp
    Indicates the 'http' action type (send HTTP request).

    .PARAMETER ActionBroadcast
    Indicates the 'broadcast' action type (Android only).

    .PARAMETER Label
    The label for the action button or link. This parameter is required.

    .PARAMETER URL
    The URL associated with the action. Required for 'view' and 'http' actions.

    .PARAMETER Clear
    If specified, adds 'clear=true' to the action, which will clear the notification after the action is triggered (view only).

    .PARAMETER Method
    The HTTP method for 'http' actions. Valid values: 'GET', 'POST', 'PUT', 'DELETE'. Defaults to 'POST'.

    .PARAMETER Body
    Optional body content for 'http' actions.

    .PARAMETER Headers
    Optional hashtable of headers for 'http' actions. Each key-value pair will be added as a header.

    .PARAMETER ClearHttp
    If specified, adds 'clear=true' to the http action.

    .PARAMETER Intent
    Optional intent for 'broadcast' actions (Android only). Defaults to 'io.heckel.ntfy.USER_ACTION'.

    .PARAMETER Extras
    Optional hashtable of extras for 'broadcast' actions (Android only).

    .PARAMETER ClearBroadcast
    If specified, adds 'clear=true' to the broadcast action.

    .EXAMPLE
    Build-NtfyAction -ActionView -Label 'Open Website' -URL 'https://example.com'

    .EXAMPLE
    Build-NtfyAction -ActionHttp -Label 'Trigger API' -URL 'https://api.example.com/trigger' -Method 'POST' -Body '{"foo":"bar"}' -Headers @{ Authorization = 'Bearer token' }

    .EXAMPLE
    Build-NtfyAction -ActionBroadcast -Label 'Custom Intent' -Intent 'io.heckel.ntfy.USER_ACTION' -Extras @{ key1 = 'value1' }

    .EXAMPLE
    # Example: Send broadcast action to take a screenshot
    $action = Build-NtfyAction -ActionBroadcast -Label 'Take Screenshot' -Extras @{ cmd = 'screenshot' }
    Send-NtfyMessage -Topic 'ntfypwsh' -Body 'Please take a screenshot.' -Action $action

    .OUTPUTS
    System.String. Returns a formatted ntfy action header string.

    .NOTES
    See https://docs.ntfy.sh/publish/#actions for more details on ntfy actions.
    Project: https://github.com/ptmorris1/NtfyPwsh

    .LINK
    https://ptmorris1.github.io/posts/NtfyPwsh-Examples/#-build-ntfyaction-cmdlet-overview
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