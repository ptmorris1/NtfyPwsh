# NtfyPwsh

![PowerShell Gallery Version](https://img.shields.io/powershellgallery/v/NtfyPwsh)
![Downloads](https://img.shields.io/powershellgallery/dt/NtfyPwsh)
![PSGallery Quality](https://img.shields.io/powershellgallery/p/NtfyPwsh)

> PowerShell module for sending notifications using the Ntfy service, supporting messages, actions, attachments, and more.

---

## 📖 Table of Contents <!-- omit in toc -->
- [NtfyPwsh](#ntfypwsh)
  - [🦾 Description](#-description)
  - [🛠 Requirements](#-requirements)
  - [📦 Installation](#-installation)
    - [Parameters](#parameters)
    - [Examples](#examples)
    - [Parameters](#parameters-1)
    - [Examples](#examples-1)
  - [🧑‍💻📚 Examples](#-examples)
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

- `Title` (String, Optional): The title of the notification.
- `Body` (String, Optional): The body content of the notification.
- `URI` (String, Optional): The base URI of the Ntfy service. Default is ntfy.sh or enter self-hosted URL.
  > **Note:** If `-URI` is not specified, messages are sent to the free public [ntfy.sh](https://ntfy.sh) server. Topics are public and there are limitations. See [public topics](https://docs.ntfy.sh/publish/?h=public#public-topics) and [limitations](https://docs.ntfy.sh/publish/?h=public#limitations) in the ntfy documentation for details.
- `Topic` (String, Mandatory): The topic for the notification. No spaces or special characters.
- `TokenCreds` (PSCredential, Optional): Credentials for Bearer token authentication (use `Get-Credential` and enter the API token as the password).
- `Credential` (PSCredential, Optional): Credentials for basic authentication (use `Get-Credential` for username/password).
- `Priority` (String, Optional): The priority of the notification (`Max`, `High`, `Default`, `Low`, `Min`).
- `Tags` (String[], Optional): Tags or emojis for the notification. [TagList](https://docs.ntfy.sh/publish/?h=topic#tags-emojis)
- `SkipCertCheck` (Switch, Optional): Skip certificate validation (for self-signed SSL, PowerShell 7+ only).
- `Delay` (String, Optional): Delay for the notification (timestamp, duration, or natural language).
- `OnClick` (String, Optional): URL to open when the notification is clicked.
- `Action` (String[] or Object[], Optional): Actions for the notification. Use with [Build-NtfyAction](#-build-ntfyaction).
- `AttachmentPath` (String, Optional): Path to the local file to attach.
- `AttachmentName` (String, Optional): Custom name for the attachment file.
- `AttachmentURL` (String, Optional): URL of the attachment to include.
- `Icon` (String, Optional): Icon URL or emoji for the notification (Android only, PNG/JPEG or emoji).
- `Email` (String, Optional): Email address for the notification.
- `Phone` (String, Optional): Phone number for the notification (must be in +<countrycode><number> format).
- `NoCache` (Switch, Optional): Prevent message from being cached on the server.
- `FirebaseNo` (Switch, Optional): Prevent forwarding to Firebase (FCM).
- `Markdown` (Switch, Optional): Enable Markdown formatting in the body (sets Content-Type to text/markdown).

### Examples

See the [Examples section](#-examples) below for usage scenarios.

---

## ⚡ Build-NtfyAction <!-- omit in toc -->

Builds [actions](https://docs.ntfy.sh/publish/#action-buttons) for the [Send-NtfyMessage](#-send-ntfymessage) -Action parameter. Up to 3 actions are allowed.

### Parameters

- `ActionView` (Switch, Mandatory for view): Specify to create a 'view' action (open website/app).
- `ActionHttp` (Switch, Mandatory for http): Specify to create an 'http' action (send HTTP request).
- `ActionBroadcast` (Switch, Mandatory for broadcast): Specify to create a 'broadcast' action (Android only).
- `Label` (String, Mandatory): The label for the action button or link.
- `URL` (String, Mandatory for view/http): The URL associated with the action.
- `Clear` (Switch, Optional for view): If specified, clears the notification after the action is triggered.
- `Method` (String, Optional for http): HTTP method for http actions. Valid: 'GET', 'POST', 'PUT', 'DELETE'. Default: 'POST'.
- `Body` (String, Optional for http): Optional body content for http actions.
- `Headers` (Hashtable, Optional for http): Optional headers for http actions.
- `ClearHttp` (Switch, Optional for http): If specified, clears the notification after the http action is triggered.
- `Intent` (String, Optional for broadcast): Optional intent for broadcast actions (Android only).
- `Extras` (Hashtable, Optional for broadcast): Optional extras for broadcast actions (Android only).
- `ClearBroadcast` (Switch, Optional for broadcast): If specified, clears the notification after the broadcast action is triggered.

### Examples

See the [Examples section](#-examples) below for usage scenarios.

---

## 🧑‍💻📚 Examples

See [`examples.md`](./examples.md) for detailed usage examples of every parameter and advanced scenarios.

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
