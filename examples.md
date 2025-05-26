# NtfyPwsh TMI edition!
<img src="/assets/imgs/ntfy.png" alt="ntfy icon" style="height:48px;vertical-align:middle;">

# Full examples with explanations for the NtfyPwsh module.

## 📬 Send-NtfyMessage Cmdlet Overview

The `Send-NtfyMessage` cmdlet is the primary way to send notifications using the NtfyPwsh module. It supports a wide range of parameters to customize your notifications, including scheduling, formatting, attachments, actions, and more.

**Parameters:**
- `-Topic` (String, Required): The topic/channel to send the notification to.
- `-Body` (String,): The main message body.
- `-Title` (String): Optional notification title.
- `-Priority` (String): Set notification priority. Valid: 'Min', 'Low', 'Default', 'High', 'Max'.
- `-Tags` (Array): Add tags or emojis to the notification.
- `-Delay` (String): Schedule delivery (timestamp, duration, or natural language).
- `-Action` (Object): Add action buttons (use with Build-NtfyAction).
- `-OnClick` (String): URL to open when notification is clicked.
- `-AttachmentPath` (String): Local file path to attach.
- `-AttachmentURL` (String): URL of file to attach.
- `-AttachmentName` (String): Custom filename for attachment.
- `-Markdown` (Switch): Enable Markdown formatting in the body.
- `-Icon` (String): URL or emoji for notification icon.
- `-Email` (String): Send notification to an email address.
- `-Phone` (String): Trigger a phone call.
- `-NoCache` (Switch): Prevent message from being cached on the server.
- `-FirebaseNo` (Switch): Prevent forwarding to Firebase (FCM).
- `-Credential` (PSCredential): PowerShell credential for basic authentication.
- `-TokenCreds` (PSCredential): PowerShell credential for API token authentication.
- `-URI` (String): Custom ntfy server URL (defaults to https://ntfy.sh).

> ℹ️ For a full parameter mapping, see the [Parameter Mapping Table](#-parameter-mapping-table).

## 📨 Publish a Basic Notification.

The simplest way to send a notification is with a topic, title, and body. This will send a notification to the default public ntfy.sh server, and anyone subscribed to the topic will receive it. You can use this for quick alerts, reminders, or any message you want to broadcast.

```powershell
$ntfy = @{
    Topic = 'ntfypwsh'
    Body  = 'This is a test message'
    Title = 'Test Title'
}
Send-NtfyMessage @ntfy
```

> 📖 **Further reading:** [ntfy documentation – Publishing](https://docs.ntfy.sh/publish/)

This sends a notification to the **public** "[ntfypwsh](https://ntfy.sh/ntfypwsh)" on ntfy.sh. **Anyone** subscribed to this topic will receive the notification. You can customize the `Topic`, `Body`, and `Title` as needed for your use case.

> 📝 **Note**: The `-URI` parameter defaults to `https://ntfy.sh` if not specified. If you're using a self-hosted instance, be sure to provide your instance URL with the `-URI` parameter.

## 📨 Sending Basic Notifications to custom URL

Add the URI parameter and your instance address.

```powershell
$ntfy = @{
    Topic = 'ntfypwsh'
    Body  = 'This is a test message'
    Title = 'Test Title'
    URI   = 'https://myntfy.mydomain.com'
}
Send-NtfyMessage @ntfy
```

## 📨 Sending with message priority

You can set the priority of your notification using the `Priority` parameter. This controls how the notification is displayed and alerted on the recipient's device.

You can set `Priority` to one of the following options:

- 'Min'
- 'Low'
- 'Default'
- 'High'
- 'Max'

Example of sending a high-priority notification:

```powershell
$ntfy = @{
    Topic    = 'ntfypwsh'
    Body     = 'This is an urgent message!'
    Title    = 'Urgent Alert'
    Priority = 'Max'
}
Send-NtfyMessage @ntfy
```

> 📖 **Further reading:** [ntfy documentation – Message Priority](https://docs.ntfy.sh/publish/#message-priority)

## 🏷️ Tags & Emojis

You can add tags (including emojis) to your notifications using the `-Tags` parameter. Tags can help categorize or visually enhance your messages. Some emojis are mapped to special tag names in ntfy.

**Some available emoji options for `-Tags` parameter:**
- 👍
- 👎️
- 🤦
- 🥳
- ⚠️
- ⛔
- 🎉
- 🚨
- 🚫
- ✔️
- 🚩
- 💿
- 📢
- 💀
- 💻

> 💡 You can use tab completion in PowerShell to pick an emoji icon, or use a text value from the emoji short code list (see the full emoji list link below).

> 📖 **Further reading:** [ntfy documentation – Tags & Emojis](https://docs.ntfy.sh/publish/#tags-emojis)
> <br>🔗 **Full emoji list:** [ntfy supported emojis](https://docs.ntfy.sh/emojis/)

Example of sending a notification with tags and emojis:

```powershell
$ntfy = @{
    Topic = 'ntfypwsh'
    Body  = 'Backup completed successfully!'
    Title = 'Backup Status'
    Tags  = @('✔️','💻','green_circle')
}
Send-NtfyMessage @ntfy
```

## 📝 Markdown Formatting Example

You can enable Markdown formatting in your notification body using the `-Markdown` parameter. For example:

```powershell
$ntfy = @{
    Topic    = 'ntfypwsh'
    Body     = "Look ma, **bold text**, *italics*, ..."
    Title    = 'Markdown baby!'
    Markdown = $true
}
Send-NtfyMessage @ntfy
```

> 📖 **Further reading:** [ntfy documentation – Markdown Formatting](https://docs.ntfy.sh/publish/#markdown-formatting)


## ⏰ Scheduled Delivery

Example of sending a scheduled notification:

You can schedule delivery by specifying:
- a Unix timestamp (e.g. `1639194738`)
- a duration (e.g. `30m`, `3h`, `2 days`)
- a natural language time string (e.g. `10am`, `tomorrow`, `Tuesday`, `7am`, etc.)

```powershell
$ntfy = @{
    Topic = 'ntfypwsh'
    Title = "Sent $((get-date).ToString())"
    Body = 'This message will be delivered after 1 minute.'
    Delay = '1m'
}
Send-NtfyMessage @ntfy
```

> 📖 **Further reading:** [ntfy documentation – Scheduled Delivery](https://docs.ntfy.sh/publish/#scheduled-delivery)
> <br>🔗 **Natural language time parser:** [when on GitHub](https://github.com/olebedev/when)

## 🛠️ Action Buttons

You can add action buttons to notifications to allow yourself to react to a notification directly. This is incredibly useful and has countless applications. For example, you can control home appliances, respond to monitoring alerts, or trigger custom automations—all from your notification.

As of today, the following actions are supported:

- **view**: Opens a website or app when the action button is tapped.  
  > 📖 [Further reading: Open website/app](https://docs.ntfy.sh/publish/#open-websiteapp)
- **broadcast**: Sends an Android broadcast intent when the action button is tapped (only supported on Android).  
  > 📖 [Further reading: Android broadcast](https://docs.ntfy.sh/publish/#send-android-broadcast)
- **http**: Sends an HTTP POST/GET/PUT/DELETE request when the action button is tapped.  
  > 📖 [Further reading: HTTP request](https://docs.ntfy.sh/publish/#send-http-request)

> 📖 **Further reading:** [ntfy documentation – Action Buttons](https://docs.ntfy.sh/publish/#action-buttons)


## 🧩 Build-NtfyAction Cmdlet Overview

You can use the `Build-NtfyAction` cmdlet to construct action button definitions for your notifications. This cmdlet helps you create properly formatted action headers for ntfy messages that require user interaction or automation. You can include up to 3 actions per notification.

**Parameters:**
- `-ActionView` (Switch): Specify to create a 'view' action (open website/app).
- `-ActionHttp` (Switch): Specify to create an 'http' action (send HTTP request).
- `-ActionBroadcast` (Switch): Specify to create a 'broadcast' action (Android only).
- `-Label` (String, Required): The label for the action button or link.
- `-URL` (String, Required for view/http): The URL associated with the action.
- `-Clear` (Switch): If specified, clears the notification after the action is triggered.
- `-Method` (String, http only): HTTP method for http actions. Valid: 'GET', 'POST', 'PUT', 'DELETE'. Default: 'POST'.
- `-Body` (String, http only): Optional body content for http actions.
- `-Headers` (Hashtable, http only): Optional headers for http actions.
- `-Intent` (String, broadcast only): Optional intent for broadcast actions (Android only).
- `-Extras` (Hashtable, broadcast only): Optional extras for broadcast actions (Android only).

### [View Action](https://docs.ntfy.sh/publish/#open-websiteapp)
```powershell
$action = Build-NtfyAction -ActionView -Label 'Open Website' -URL 'https://ntfy.sh'
$ntfy = @{
    Topic  = 'ntfypwsh'
    Title = 'Ntfy link'
    Body   = 'Tap to open ntfy.'
    Action = $action
}
Send-NtfyMessage @ntfy
```

### [HTTP Action](https://docs.ntfy.sh/publish/#send-http-request)
```powershell
$http = @{
    ActionHttp = $true
    Label = 'Publish Ntfy.sh'
    URL = 'https://ntfy.sh/ntfypwsh'
    Body = 'Sent a post api to myself'
}

$action = Build-NtfyAction @http

$ntfy = @{
    Topic = 'ntfypwsh'
    Action = $action
    Title = 'Send a Post HTTP'
    Body = 'This will publish another message to this topic'
}

Send-NtfyMessage @ntfy
```

### [Broadcast Action](https://docs.ntfy.sh/publish/#send-android-broadcast) (Android only)
```powershell
$broadcast = @{
    ActionBroadcast = $true
    Label = 'Take Screenshot'
    Extras = @{
        cmd = 'screenshot'
    }
}

$action = Build-NtfyAction @broadcast

$SendBroadcast = @{
    Topic = 'ntfypwsh'
    Action = $action
    Title = 'screenshot'
    Body = 'Please take a screenshot.'
    TokenCreds = $creds
}

Send-NtfyMessage @SendBroadcast
```

## 🖱️ Click Action Example

You can use the `-OnClick` parameter to specify a URL to open when the notification is clicked. For example, to open Reddit messages when the notification is clicked:

```powershell
$ntfy = @{
    Topic  = 'ntfypwsh'
    Body   = 'Check out Ntfy!'
    OnClick = 'https://ntfy.sh'
}
Send-NtfyMessage @ntfy
```

> 📖 **Further reading:** [ntfy documentation – Click Action](https://docs.ntfy.sh/publish/#click-action)

## 📎 Local File Attachment Example

You can attach a local file to your notification using the `-AttachmentPath` parameter. For example:

```powershell
$ntfy = @{
    Topic          = 'ntfypwsh'
    Body           = 'This is a test message with attachment'
    Title          = 'Test attachment'
    AttachmentPath = 'D:\Downloads\avatar.jpg'
    AttachmentName = 'My Avatar'
}
Send-NtfyMessage @ntfy
```

> 📖 **Further reading:** [ntfy documentation – Attach Local File](https://docs.ntfy.sh/publish/#attach-local-file)

## 🌐 Attachment from URL Example

You can attach a file from a URL to your notification using the `-AttachmentURL` parameter. For example:

```powershell
$ntfy = @{
    Topic         = 'ntfypwsh'
    Body          = 'This message has an attachment from a URL.'
    Title         = 'Attachment from URL'
    AttachmentURL = 'https://github.com/loganmarchione/homelab-svg-assets/blob/main/assets/ntfy.svg'
}
Send-NtfyMessage @ntfy
```

> 📖 **Further reading:** [ntfy documentation – Attach File from a URL](https://docs.ntfy.sh/publish/#attach-file-from-a-url)

## 🖼️ Icon Example (Android only)

You can specify an icon for your notification using the `-Icon` parameter. The icon can be a URL to a PNG/JPEG image or an emoji (`Android only`). For example:

```powershell
$ntfy = @{
    Topic = 'ntfypwsh'
    Body  = 'This message has a custom icon.'
    Title = 'Icon Example'
    Icon  = 'https://styles.redditmedia.com/t5_32uhe/styles/communityIcon_xnt6chtnr2j21.png'
}
Send-NtfyMessage @ntfy
```

> 📖 **Further reading:** [ntfy documentation – Icons](https://docs.ntfy.sh/publish/#icons)

## 📧 Email Notification Example

You can send a notification to an email address using the `-Email` parameter. For example:

```powershell
$ntfy = @{
    Topic = 'ntfypwsh'
    Body  = 'This message will be sent to your email.'
    Title = 'Email Example'
    Email = 'email@email.com'
}
Send-NtfyMessage @ntfy
```

> 📖 **Further reading:** [ntfy documentation – E-mail Notifications](https://docs.ntfy.sh/publish/#e-mail-notifications)

## 📞 Phone Call Example

You can send a notification that triggers a phone call using the `-Phone` parameter. The phone number must be in international format (e.g. +12345678901). For example:

```powershell
$ntfy = @{
    Topic = 'ntfypwsh'
    Body  = 'This message will trigger a phone call.'
    Title = 'Phone Call Example'
    Phone = '+12345678901'
}
Send-NtfyMessage @ntfy
```

> 📖 **Further reading:** [ntfy documentation – Phone Calls](https://docs.ntfy.sh/publish/#phone-calls)

## 🚫 No-Cache Example

You can prevent a message from being cached on the server using the `-NoCache` parameter. For example:

```powershell
$ntfy = @{
    Topic   = 'ntfypwsh'
    Body    = 'This message will not be cached on the server.'
    Title   = 'No-Cache Example'
    NoCache = $true
}
Send-NtfyMessage @ntfy
```

> 📖 **Further reading:** [ntfy documentation – Message Caching](https://docs.ntfy.sh/publish/#message-caching)

## 📵 Disable Firebase Forwarding Example

You can prevent a message from being forwarded (if configured) to Firebase (FCM) using the `-FirebaseNo` parameter. For example:

```powershell
$ntfy = @{
    Topic      = 'ntfypwsh'
    Body       = "This message won't be forwarded to FCM."
    Title      = 'No Firebase Example'
    FirebaseNo = $true
}
Send-NtfyMessage @ntfy
```

> 📖 **Further reading:** [ntfy documentation – Disable Firebase](https://docs.ntfy.sh/publish/#disable-firebase)

## 🔐 Authentication Examples

You can authenticate with ntfy using either basic authentication (username and password) or an API token. For more details, see the [ntfy documentation – Authentication](https://docs.ntfy.sh/publish/#authentication).

### Basic Authentication (Username & Password)

```powershell
$creds = Get-Credential -UserName ntfy # change to username, run command and enter password.
$ntfy = @{
    Topic      = 'ntfypwsh'
    Body       = 'This message uses basic authentication.'
    Title      = 'Basic Auth Example'
    Credential = $creds
}
Send-NtfyMessage @ntfy
```

### API Token Authentication

```powershell
$token = Get-Credential -UserName ntfy # Enter your API token as the password, username can be anything
$ntfy = @{
    Topic      = 'ntfypwsh'
    Body       = 'This message uses API token authentication.'
    Title      = 'API Token Example'
    TokenCreds = $token
}
Send-NtfyMessage @ntfy
```

## 📑 Parameter Mapping Table

Below is a mapping of ntfy headers/parameters to the corresponding PowerShell parameters in Send-NtfyMessage:

| ntfy Header      | Aliases                        | PowerShell Parameter      | Description                                                      |
|------------------|-------------------------------|--------------------------|------------------------------------------------------------------|
| X-Message        | Message, m                    | Body                     | Main body of the message as shown in the notification            |
| X-Title          | Title, t                      | Title                    | Message title                                                    |
| X-Priority       | Priority, prio, p             | Priority                 | Message priority                                                 |
| X-Tags           | Tags, Tag, ta                 | Tags                     | Tags and emojis                                                  |
| X-Delay          | Delay, X-At, At, X-In, In     | Delay                    | Timestamp or duration for delayed delivery                       |
| X-Actions        | Actions, Action               | Action                   | JSON array or short format of user actions                       |
| X-Click          | Click                         | OnClick                  | URL to open when notification is clicked                         |
| X-Attach         | Attach, a                     | AttachmentURL            | URL to send as an attachment (alternative to file upload)        |
| X-Markdown       | Markdown, md                  | Markdown                 | Enable Markdown formatting in the notification body              |
| X-Icon           | Icon                          | Icon                     | URL to use as notification icon                                  |
| X-Filename       | Filename, file, f             | AttachmentName           | Optional attachment filename, as it appears in the client        |
| X-Email          | X-E-Mail, Email, E-Mail, mail, e | Email                  | E-mail address for e-mail notifications                          |
| X-Call           | Call                          | Phone                    | Phone number for phone calls                                     |
| X-Cache          | Cache                         | NoCache                  | Allows disabling message caching                                 |
| X-Firebase       | Firebase                      | FirebaseNo               | Allows disabling sending to Firebase                             |
| X-UnifiedPush    | UnifiedPush, up               | (not exposed)            | UnifiedPush publish option, only to be used by UnifiedPush apps  |
| X-Poll-ID        | Poll-ID                       | (not exposed)            | Internal parameter, used for iOS push notifications              |
| Authorization    | -                             | Credential/TokenCreds     | For authentication (username/password or API token)              |
| Content-Type     | -                             | Markdown (if set to markdown) | If set to text/markdown, Markdown formatting is enabled     |

