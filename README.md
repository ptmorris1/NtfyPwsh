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
````
