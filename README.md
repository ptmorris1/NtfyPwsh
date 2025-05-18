# NtfyPwsh

![PowerShell Gallery Version](https://img.shields.io/powershellgallery/v/NtfyPwsh)
![Downloads](https://img.shields.io/powershellgallery/dt/NtfyPwsh)
![PSGallery Quality](https://img.shields.io/powershellgallery/p/NtfyPwsh)

> PowerShell module for sending notifications using the Ntfy service, supporting messages, actions, attachments, and more.

---

## 📖 Table of Contents <!-- omit in toc -->
- [🦾 Description](#-description)
- [🛠 Requirements](#-requirements)
- [📦 Installation](#-installation)
- [📚 Available Functions](#-available-functions)
- [📝 Send-NtfyMessage](#-send-ntfymessage)
- [⚡ Build-NtfyAction](#-build-ntfyaction)
- [🧑‍💻 Examples](#-examples)
- [📰 Changelog](#-changelog)
- [🌐 Further Reading](#-further-reading)
- [📄 License](#-license)

---

## 🦾 Description

NtfyPwsh is a PowerShell module for sending notifications using the Ntfy service. This module allows you to send messages with various actions, attachments, and other customizations.

---

## 🛠 Requirements

* PowerShell 7 or higher
* Access to the internet or your self-hosted Ntfy server

---

## 📦 Installation

The module is hosted on the [Powershell Gallery](https://www.powershellgallery.com/packages/NtfyPwsh)

```powershell
Install-Module -Name NtfyPwsh
```

---

## 📚 Available Functions <!-- omit in toc -->

- [Send-NtfyMessage](#-send-ntfymessage)
- [Build-NtfyAction](#-build-ntfyaction)

---

## 📝 Send-NtfyMessage <!-- omit in toc -->

Sends a notification using the Ntfy service.

> **Note:** As of v0.4.0, authentication uses `-TokenCreds` (API token via `Get-Credential`) or `-Credential` (username/password via `Get-Credential`). The `-TokenPlainText` parameter has been removed.

### Parameters

- `Title` (Optional): The title of the notification.
- `Body` (Optional): The body content of the notification.
- `URI` (Optional): The base URI of the Ntfy service. Default is ntfy.sh or enter self hosted URL.
  > **Note:** If `-URI` is not specified, messages are sent to the free public [ntfy.sh](https://ntfy.sh) server. Topics are public and there are limitations. See [public topics](https://docs.ntfy.sh/publish/?h=public#public-topics) and [limitations](https://docs.ntfy.sh/publish/?h=public#limitations) in the ntfy documentation for details.
- `Topic` (Mandatory): The topic for the notification. No spaces or special characters.
- `TokenCreds` (Optional): The credentials for token-based authentication (use `Get-Credential` and enter the API token as the password).
- `Credential` (Optional): Credentials for basic authentication (use `Get-Credential` for username/password).
- `Priority` (Optional): The priority of the notification (`Max`, `High`, `Default`, `Low`, `Min`).
- `Tags` (Optional): Tags for the notification. [TagList](https://docs.ntfy.sh/publish/?h=topic#tags-emojis)
- `SkipCertCheck` (Optional): A switch to skip certificate checks.
- `Delay` (Optional): Delay for the notification.
- `OnClick` (Optional): URL to open when the notification is clicked.
- `Action` (Optional): Actions for the notification. [Docs](https://docs.ntfy.sh/publish/?h=topic#action-buttons)
- `AttachmentPath` (Optional): Path to the attachment file.
- `AttachmentName` (Optional): Name of the attachment file.
- `AttachmentURL` (Optional): URL of the attachment.
- `Icon` (Optional): Icon URL for the notification. Only for Android. Only PNG or JPEG.
- `Email` (Optional): Email address for the notification.
- `Phone` (Optional): Phone number for the notification.

### Examples

See the [Examples section](#-examples) below for usage scenarios.

---

## ⚡ Build-NtfyAction <!-- omit in toc -->

Builds [actions](https://docs.ntfy.sh/publish/#action-buttons) for the [Send-NtfyMessage](#-send-ntfymessage) -Action parameter. Up to 3 actions are allowed.

### Parameters

- `Action` (Mandatory): The type of action (`view`, `http`, `broadcast`).
- `Label` (Mandatory): The label for the action.
- `URL` (Mandatory): The URL for the action.
- `Clear` (Optional): A switch to clear the action.
- `Method` (Optional): The HTTP method (`GET`, `POST`, `PUT`, `DELETE`).
- `Body` (Optional): The body content for the HTTP action.
- `Headers` (Optional): The headers for the HTTP action.
- `Intent` (Optional): The intent for the broadcast action.
- `Extras` (Optional): Additional extras for the broadcast action.

### Examples

See the [Examples section](#-examples) below for usage scenarios.

---

## 🧑‍💻 Examples

> For more detailed descriptions of these examples, see the [ntfy publish documentation](https://docs.ntfy.sh/publish/).

### Post a basic message with only a message body to the default URI https://ntfy.sh

```powershell
Send-NtfyMessage -Topic 'ntfypwsh' -Body 'Hello from NtfyPwsh!'
```

### Post a message to a custom Ntfy server URI

```powershell
Send-NtfyMessage -Topic 'ntfypwsh' -Body 'Hello from my self-hosted Ntfy!' -URI 'https://ntfy.example.com'
```

### Post a message with a custom title

```powershell
$ntfy = @{
    Topic = 'ntfypwsh'
    Title = 'Dogs are better than cats'
    Body  = 'Oh my ...'
}
Send-NtfyMessage @ntfy
```

### Post a message with title, priority, and tags

```powershell
$ntfy = @{
    Topic    = 'ntfypwsh'
    Title    = 'Unauthorized access detected'
    Priority = 'Max'
    Tags     = @('warning','skull')
    Body     = 'Remote access to phils-laptop detected. Act right away.'
}
Send-NtfyMessage @ntfy
```

### Post a multi-line message with click action, action button, image attachment, and email

```powershell
$ntfy = @{
    Topic         = 'ntfypwsh'
    Body          = @"
There's someone at the door. 🐶

Please check if it's a good boy or a hooman.
Doggies have been known to ring the doorbell.
"@
    OnClick       = 'https://home.nest.com'
    AttachmentURL = 'https://ibb.co/JjSRzMSk'
    Action        = @(Build-NtfyAction -Action http -Label 'Open door' -URL 'https://api.nest.com/open/yAxkasd' -Clear)
    Email         = 'phil@example.com'
}
Send-NtfyMessage @ntfy
```

### Notification with 2 Actions, using Build-NtfyAction variables

```powershell
$action1 = Build-NtfyAction -Action view -Label 'View Action' -URL 'https://ntfy.sh'
$action2 = Build-NtfyAction -Action http -Label 'http Action' -URL 'https://ntfy.sh/ntfypwsh' -Body 'I jut sent a message to myself!' -Method POST
Send-NtfyMessage -Topic 'ntfypwsh' -Action @($action1,$action2)
```

### Notification with Local File Attachment

```powershell
$ntfy = @{
    Topic          = 'ntfypwsh'
    Body           = 'This is a test message with attachment'
    Title          = 'Test attachment'
    AttachmentPath = 'D:/path/to/attachment.png'
    AttachmentName = 'attachment.png'
}
Send-NtfyMessage @ntfy
```

### Basic authentication example (use when your server requires username and password)

```powershell
$creds = Get-Credential -UserName 'your-username'  # Enter your username and password
Send-NtfyMessage -Topic 'ntfypwsh' -Body 'Message with Basic Auth' -Credential $creds
```

### Bearer token authentication example (use when your server requires an API token)

```powershell
$tokenCreds = Get-Credential -UserName 'api'  # Enter your API token as the password
Send-NtfyMessage -Topic 'ntfypwsh' -Body 'Message with Bearer token' -TokenCreds $tokenCreds
```

### Scheduled delivery example

```powershell
$ntfy = @{
    Topic = 'ntfypwsh'
    Body  = 'This message will be delivered in 1 hour.'
    Delay = '1h'  # You can use values like '30m', '2 days', 'tomorrow', or a Unix timestamp
}
Send-NtfyMessage @ntfy
```

### Forward notification to email example

```powershell
$ntfy = @{
    Topic = 'ntfypwsh'
    Body  = 'This message will be forwarded to your email.'
    Email = 'user@example.com'  # Only one address is supported at a time
}
Send-NtfyMessage @ntfy
```

### Forward notification to phone example

> You can use ntfy to call a phone and read the message out loud using text-to-speech. Phone numbers must be previously verified (via the web app), and authentication is required. On ntfy.sh, this feature is only available to Pro plans. [More info](https://docs.ntfy.sh/publish/?h=public#phone-calls)

```powershell
$ntfy = @{
    Topic = 'ntfypwsh'
    Body  = 'This message will be read out loud to your phone.'
    Phone = '+12223334444'  # Use +<countrycode><number> format for a verified number, or 'yes' to use your first verified number
}
Send-NtfyMessage @ntfy
```

# The Delay parameter supports durations (e.g. '30m', '2h'), natural language (e.g. 'tomorrow', '10am'), or Unix timestamps. Minimum delay is 10 seconds, maximum is 3 days (server configurable).

---

## 📰 Changelog

See the [Changelog](changelog.md) for a history of notable changes to this module.

---

## 🌐 Further Reading

- [NtfyPwsh Blog](https://ptmorris1.github.io/posts/NtfyPwsh)
- [Ntfy Docs for Publishing mesages](https://docs.ntfy.sh/publish/)

---

## 📄 License

This project is licensed under the MIT License.
