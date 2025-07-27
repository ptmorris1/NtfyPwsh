---
document type: cmdlet
external help file: ntfypwsh-Help.xml
HelpUri: https://ptmorris1.github.io/posts/NtfyPwsh-Examples/
Locale: en-US
Module Name: ntfypwsh
ms.date: 07/27/2025
PlatyPS schema version: 2024-05-01
title: Send-NtfyMessage
---

# Send-NtfyMessage

## SYNOPSIS

Sends a message to an ntfy topic with optional customization and authentication.

## SYNTAX

### Anonymous (Default)

```
Send-NtfyMessage -Topic <string> [-Title <string>] [-Body <string>] [-URI <string>]
 [-Phone <string>] [-Priority <string>] [-Tags <string[]>] [-SkipCertCheck] [-Delay <string>]
 [-OnClick <string>] [-Action <array>] [-AttachmentPath <string>] [-AttachmentName <string>]
 [-AttachmentURL <string>] [-Icon <string>] [-Email <string>] [-Credential <pscredential>]
 [-TokenCreds <pscredential>] [-NoCache] [-Markdown] [-FirebaseNo] [<CommonParameters>]
```

### TokenCreds

```
Send-NtfyMessage -Topic <string> [-Title <string>] [-Body <string>] [-URI <string>]
 [-Phone <string>] [-Priority <string>] [-Tags <string[]>] [-SkipCertCheck] [-Delay <string>]
 [-OnClick <string>] [-Action <array>] [-AttachmentPath <string>] [-AttachmentName <string>]
 [-AttachmentURL <string>] [-Icon <string>] [-Email <string>] [-TokenCreds <pscredential>]
 [-NoCache] [-Markdown] [-FirebaseNo] [<CommonParameters>]
```

### Credential

```
Send-NtfyMessage -Topic <string> [-Title <string>] [-Body <string>] [-URI <string>]
 [-Phone <string>] [-Priority <string>] [-Tags <string[]>] [-SkipCertCheck] [-Delay <string>]
 [-OnClick <string>] [-Action <array>] [-AttachmentPath <string>] [-AttachmentName <string>]
 [-AttachmentURL <string>] [-Icon <string>] [-Email <string>] [-Credential <pscredential>]
 [-NoCache] [-Markdown] [-FirebaseNo] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Sends a message to an ntfy topic using the ntfy REST API.
Supports custom title, body, priority, tags, actions, attachments (local file or URL), icons, email, phone, delayed/scheduled delivery, click actions, markdown formatting, no-cache, disable Firebase forwarding, and more.
Allows for authentication using either Basic (username/password) or Bearer (API token) methods.
Can be used with public ntfy.sh or self-hosted ntfy instances.
Supports PowerShell credential objects for authentication.
Compatible with all ntfy features as of module version.

## EXAMPLES

### EXAMPLE 1

Send-NtfyMessage -Topic 'ntfypwsh' -Title 'Hello' -Body 'This is a test message'

### EXAMPLE 2

$creds = Get-Credential -UserName api
Send-NtfyMessage -Topic 'ntfypwsh' -Body 'With Bearer token' -TokenCreds $creds

### EXAMPLE 3

$creds = Get-Credential -UserName user
Send-NtfyMessage -Topic 'ntfypwsh' -Body 'With Basic Auth' -Credential $creds

### EXAMPLE 4

Send-NtfyMessage -Topic 'ntfypwsh' -Body 'With attachment' -AttachmentPath 'C:\temp\file.txt'

### EXAMPLE 5

Send-NtfyMessage -Topic 'ntfypwsh' -Body 'With attachment from URL' -AttachmentURL 'https://example.com/file.txt'

### EXAMPLE 6

Send-NtfyMessage -Topic 'ntfypwsh' -Body 'With icon' -Icon 'https://example.com/icon.png'

### EXAMPLE 7

Send-NtfyMessage -Topic 'ntfypwsh' -Body 'With click action' -OnClick 'https://example.com'

### EXAMPLE 8

Send-NtfyMessage -Topic 'ntfypwsh' -Body 'With scheduled delivery' -Delay '10m'

### EXAMPLE 9

Send-NtfyMessage -Topic 'ntfypwsh' -Body 'With markdown' -Markdown

### EXAMPLE 10

Send-NtfyMessage -Topic 'ntfypwsh' -Body "This message won't be stored server-side" -NoCache

### EXAMPLE 11

Send-NtfyMessage -Topic 'ntfypwsh' -Body "This message won't be forwarded to FCM" -FirebaseNo

## PARAMETERS

### -Action

Optional actions to include with the message.
Use Build-NtfyAction to construct these.
Supports up to 3 actions.

```yaml
Type: System.Array
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Anonymous
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: TokenCreds
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Credential
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -AttachmentName

Optional name for the attached file.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Anonymous
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: TokenCreds
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Credential
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -AttachmentPath

Optional path to a file to attach to the message.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Anonymous
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: TokenCreds
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Credential
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -AttachmentURL

Optional URL to an attachment (remote file).

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Anonymous
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: TokenCreds
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Credential
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Body

The body content of the message (optional).

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Anonymous
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: TokenCreds
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Credential
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Credential

PSCredential object for Basic authentication (mutually exclusive with TokenCreds).

```yaml
Type: System.Management.Automation.PSCredential
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Anonymous
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Credential
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Delay

Optional delay for the message (RFC3339 timestamp, duration string, or natural language).

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Anonymous
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: TokenCreds
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Credential
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Email

Optional email address for the message.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Anonymous
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: TokenCreds
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Credential
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -FirebaseNo

If specified, adds a header to prevent forwarding the message to Firebase (sets Firebase=no).

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Anonymous
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: TokenCreds
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Credential
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Icon

Optional icon for the message (URL or emoji).

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Anonymous
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: TokenCreds
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Credential
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Markdown

If specified, adds 'Content-Type' = 'text/markdown' to the headers.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Anonymous
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: TokenCreds
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Credential
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -NoCache

If specified, adds a header to prevent the message from being cached server-side (sets Cache=no).

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Anonymous
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: TokenCreds
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Credential
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -OnClick

Optional URL to open when the message is clicked.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Anonymous
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: TokenCreds
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Credential
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Phone

Optional phone number for the message (must be in +<countrycode><number> format).

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Anonymous
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: TokenCreds
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Credential
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Priority

The priority level of the message.
Valid values: 'Max', 'High', 'Default', 'Low', 'Min'.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Anonymous
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: TokenCreds
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Credential
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SkipCertCheck

If specified, skips certificate validation for self-signed SSL certificates (PowerShell 7+ only).

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Anonymous
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: TokenCreds
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Credential
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Tags

Optional tags for the message.
Can be emoji or text.
Some emoji are mapped to ntfy tag names.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Anonymous
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: TokenCreds
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Credential
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Title

The title of the message (optional).

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Anonymous
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: TokenCreds
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Credential
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -TokenCreds

PSCredential object for Bearer token authentication (mutually exclusive with Credential).
Use the token as the password.

```yaml
Type: System.Management.Automation.PSCredential
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Anonymous
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: TokenCreds
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Topic

The topic to which the message will be sent.
Must not contain spaces or special characters.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Anonymous
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: TokenCreds
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Credential
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -URI

The base URI for the ntfy instance.
Defaults to https://ntfy.sh if not specified.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Anonymous
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: TokenCreds
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Credential
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Object. Returns the ntfy response object

{{ Fill in the Description }}

## NOTES

See https://docs.ntfy.sh/publish/ for more details on ntfy message options.
Project: https://github.com/ptmorris1/NtfyPwsh


## RELATED LINKS

- [](https://ptmorris1.github.io/posts/NtfyPwsh-Examples/)
