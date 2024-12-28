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

function Send-NtfyMessage {
    param (
        [string]$Title,

        [string]$Body,

        [string]$URI,

        [Parameter(Mandatory)]
        [string]$Topic,

        [Parameter(Mandatory = $true, ParameterSetName = 'token')]
        [Parameter(Mandatory = $false, ParameterSetName = 'action')]
        [Parameter(Mandatory = $false, ParameterSetName = 'attachment')]
        [Parameter(Mandatory = $false, ParameterSetName = 'attachmentURL')]
        [string]$TokenPlainText,

        [Parameter(Mandatory = $true, ParameterSetName = 'tokenCreds')]
        [Parameter(Mandatory = $false, ParameterSetName = 'action')]
        [Parameter(Mandatory = $false, ParameterSetName = 'attachment')]
        [Parameter(Mandatory = $false, ParameterSetName = 'attachmentURL')]
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

        [Parameter(Mandatory = $true, ParameterSetName = 'action')]
        [Parameter(Mandatory = $false, ParameterSetName = 'attachment')]
        [Parameter(Mandatory = $false, ParameterSetName = 'attachmentURL')]
        [array]$Action,

        [Parameter(Mandatory = $true, ParameterSetName = 'attachment')]
        [Parameter(Mandatory = $false, ParameterSetName = 'attachmentURL')]
        [string]$AttachmentPath,

        [Parameter(Mandatory = $true, ParameterSetName = 'attachment')]
        [Parameter(Mandatory = $false, ParameterSetName = 'attachmentURL')]
        [string]$AttachmentName,

        [Parameter(Mandatory = $true, ParameterSetName = 'attachmentURL')]
        [Parameter(Mandatory = $false, ParameterSetName = 'attachment')]
        [Parameter(Mandatory = $false, ParameterSetName = 'user')]
        [Parameter(Mandatory = $false, ParameterSetName = 'token')]
        [Parameter(Mandatory = $false, ParameterSetName = 'tokenCreds')]
        [Parameter(Mandatory = $false, ParameterSetName = 'action')]
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
            $ntfyTags = $Tags | ForEach-Object {
                switch ($_) {
                    '👍' { '+1' }
                    '👎️' { '-1' }
                    '🤦' { 'facepalm' }
                    '🥳' { 'party' }
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
            } -join ','
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
        return $response
        #$PSCmdlet.ParameterSetName
    }
}