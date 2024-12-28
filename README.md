# NtfyPwsh

NtfyPwsh is a PowerShell module for sending notifications using the Ntfy service. This module allows you to send messages with various actions, attachments, and other customizations.

## Installation

To use the NtfyPwsh module, simply import the module into your PowerShell session:

```powershell
Import-Module -Name "D:/OneDrive/Documents/PowerShell/Homelab/NtfyPwsh.psm1"
```

## Functions

### `Build-NtfyAction`

Builds [actions](https://docs.ntfy.sh/publish/#action-buttons) for the [Send-NtfyMessage](#send-ntfymessage) -Action parameter.

#### Parameters

- `Action` (Mandatory): The type of action (`view`, `http`, `broadcast`).
- `Label` (Mandatory): The label for the action.
- `URL` (Mandatory): The URL for the action.
- `Clear` (Optional): A switch to clear the action.
- `Method` (Optional): The HTTP method (`GET`, `POST`, `PUT`, `DELETE`).
- `Body` (Optional): The body content for the HTTP action.
- `Headers` (Optional): The headers for the HTTP action.
- `Intent` (Optional): The intent for the broadcast action.
- `Extras` (Optional): Additional extras for the broadcast action.

## Examples

### Creates a view action in a vairable that can be used with Send-NtfyMessage

```powershell
$action1 = Build-NtfyAction -Action view -Label 'View Action' -URL 'https://ntfy.sh'
```

### Creates an http action in a vairable that can be used with Send-NtfyMessage

```powershell
$action2 = Build-NtfyAction -Action http -Label 'http Action' -URL 'https://ntfy.sh' -Body 'BodyPost'
```

### Sends message using $action1 and $action2.

```powershell
$action1 = Build-NtfyAction -Action view -Label 'View Action' -URL 'https://ntfy.sh'
$action2 = Build-NtfyAction -Action http -Label 'http Action' -URL 'https://ntfy.sh' -Body 'BodyPost'
Send-NtfyMessage -Topic 'test' -Action @($action1,$action2)
```

### Sends message with actions defined.

```powershell
Send-NtfyMessage -Topic 'test' -Action @(Build-NtfyAction -Action http -Label 'http Action' -URL 'https://ntfy.sh' -Body 'BodyPost',Build-NtfyAction -Action view -Label 'View Action' -URL 'https://ntfy.sh')
```
---
### `Send-NtfyMessage`

Sends a notification using the Ntfy service.

#### Parameters

- `Title` (Optional): The title of the notification.
- `Body` (Optional): The body content of the notification.
- `URI` (Optional): The base URI of the Ntfy service.  Default is ntfy.sh or enter self hosted URL.
- `Topic` (Mandatory): The topic for the notification.  No spaces or special characters.
- `TokenPlainText` (Optional): The plain text token for authentication.
- `TokenCreds` (Optional): The credentials for token-based authentication.
- `Credential` (Optional): Credentials for basic authentication.
- `Priority` (Optional): The priority of the notification (`Max`, `High`, `Default`, `Low`, `Min`).
- `Tags` (Optional): Tags for the notification.  [Docs](https://docs.ntfy.sh/publish/?h=topic#tags-emojis)
- `SkipCertCheck` (Optional): A switch to skip certificate checks.
- `Delay` (Optional): Delay for the notification.
- `OnClick` (Optional): URL to open when the notification is clicked.
- `Action` (Optional): Actions for the notification. [Docs](https://docs.ntfy.sh/publish/?h=topic#action-buttons)
- `AttachmentPath` (Optional): Path to the attachment file.
- `AttachmentName` (Optional): Name of the attachment file.
- `AttachmentURL` (Optional): URL of the attachment.
- `Icon` (Optional): Icon URL for the notification.  Only for Andriod.  Only PNG or JPEG.
- `Email` (Optional): Email address for the notification.
- `Phone` (Optional): Phone number for the notification.


## Examples

### Simple Notification with NO authorization

```powershell
$ntfy = @{
    URI   = 'https://ntfy.sh'
    Topic = 'testtopic'
    Body  = 'This is a test message'
    Title = 'Test Title'
}

Send-NtfyMessage @ntfy
```

### Simple Notification with api token Bearer/Basic authorization

```powershell
# user name does not matter.  You will be asked to enter API Token.
$Creds = Get-Credential -UserName 'admin' -Message 'Enter API Token'
$ntfy = @{
    URI   = 'https://ntfy.sh'
    Topic = 'testtopic'
    Body  = 'This is a test message'
    Title = 'Test Title'
    TokenCreds = $Creds
}

Send-NtfyMessage @ntfy
```

### Simple Notification with api token plain text, Bearer/Basic authorization.

```powershell
# Uses plain text token.
$ntfy = @{
    URI   = 'https://ntfy.sh'
    Topic = 'testtopic'
    Body  = 'This is a test message'
    Title = 'Test Title'
    TokenPlainText = 'tk_mytokenplaintexthere'
}

Send-NtfyMessage @ntfy
```

### Simple Notification with username\password, Basic authorization.

```powershell
# User name is required here.
$Creds = Get-Credential -UserName 'admin' -Message 'enter users password'
$ntfy = @{
    URI   = 'https://ntfy.sh'
    Topic = 'testtopic'
    Body  = 'This is a test message'
    Title = 'Test Title'
    Credential = $Creds
}

Send-NtfyMessage @ntfy
```

### Notification with 2 Actions

```powershell
$ntfy = @{
    URI   = 'https://ntfy.sh'
    Topic = 'test'
    Body  = 'This is a test message with actions'
    Title = 'Test Notification'
    Action = @(
        (Build-NtfyAction -Action view -Label 'View Action' -URL 'https://ntfy.sh/test')
        (Build-NtfyAction -Action http -Label 'HTTP Action' -URL 'https://ntfy.sh/test' -Method POST -Body 'Ntfy action click sent this message')
    )
}

Send-NtfyMessage @ntfy
```

### Notification with Attachment

```powershell
$ntfy = @{
    URI            = 'https://ntfy.sh'
    Topic          = 'test'
    Body           = 'This is a test message with attachment'
    Title          = 'Test attachment'
    AttachmentPath = 'D:/path/to/attachment.png'
    AttachmentName = 'attachment.png'
}

Send-NtfyMessage @ntfy
```

## License

This project is licensed under the MIT License.