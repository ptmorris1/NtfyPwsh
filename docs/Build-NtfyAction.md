---
document type: cmdlet
external help file: ntfypwsh-Help.xml
HelpUri: https://ptmorris1.github.io/posts/NtfyPwsh-Examples
Locale: en-US
Module Name: ntfypwsh
ms.date: 07/27/2025
PlatyPS schema version: 2024-05-01
title: Build-NtfyAction
---

# Build-NtfyAction

## SYNOPSIS

Builds a properly formatted ntfy action header string for use with ntfy message actions.

## SYNTAX

### View (Default)

```
Build-NtfyAction -ActionView -Label <string> -URL <string> [-Clear] [<CommonParameters>]
```

### Http

```
Build-NtfyAction -ActionHttp -Label <string> -URL <string> [-Method <string>] [-Headers <hashtable>]
 [-Body <string>] [-ClearHttp] [<CommonParameters>]
```

### Broadcast

```
Build-NtfyAction -ActionBroadcast -Label <string> [-Intent <string>] [-Extras <hashtable>]
 [-ClearBroadcast] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Constructs an ntfy action header string based on the provided parameters.
Supports 'view', 'http', and 'broadcast' actions, and allows for optional HTTP methods, headers, body, intent, extras, and clear options.
This function is useful for building the Actions header for ntfy messages that require user interaction or automation.
Supports up to 3 actions per notification.

## EXAMPLES

### EXAMPLE 1

Build-NtfyAction -ActionView -Label 'Open Website' -URL 'https://example.com'

### EXAMPLE 2

Build-NtfyAction -ActionHttp -Label 'Trigger API' -URL 'https://api.example.com/trigger' -Method 'POST' -Body '{"foo":"bar"}' -Headers @{ Authorization = 'Bearer token' }

### EXAMPLE 3

Build-NtfyAction -ActionBroadcast -Label 'Custom Intent' -Intent 'io.heckel.ntfy.USER_ACTION' -Extras @{ key1 = 'value1' }

### EXAMPLE 4

# Example: Send broadcast action to take a screenshot
$action = Build-NtfyAction -ActionBroadcast -Label 'Take Screenshot' -Extras @{ cmd = 'screenshot' }
Send-NtfyMessage -Topic 'ntfypwsh' -Body 'Please take a screenshot.' -Action $action

## PARAMETERS

### -ActionBroadcast

Indicates the 'broadcast' action type (Android only).

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Broadcast
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ActionHttp

Indicates the 'http' action type (send HTTP request).

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Http
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ActionView

Indicates the 'view' action type (open website/app).

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: View
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Body

Optional body content for 'http' actions.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Http
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Clear

If specified, adds 'clear=true' to the action, which will clear the notification after the action is triggered (view only).

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: View
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ClearBroadcast

If specified, adds 'clear=true' to the broadcast action.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Broadcast
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ClearHttp

If specified, adds 'clear=true' to the http action.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Http
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Extras

Optional hashtable of extras for 'broadcast' actions (Android only).

```yaml
Type: System.Collections.Hashtable
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Broadcast
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Headers

Optional hashtable of headers for 'http' actions.
Each key-value pair will be added as a header.

```yaml
Type: System.Collections.Hashtable
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Http
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Intent

Optional intent for 'broadcast' actions (Android only).
Defaults to 'io.heckel.ntfy.USER_ACTION'.

```yaml
Type: System.String
DefaultValue: io.heckel.ntfy.USER_ACTION
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Broadcast
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Label

The label for the action button or link.
This parameter is required.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Broadcast
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Http
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: View
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Method

The HTTP method for 'http' actions.
Valid values: 'GET', 'POST', 'PUT', 'DELETE'.
Defaults to 'POST'.

```yaml
Type: System.String
DefaultValue: POST
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Http
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -URL

The URL associated with the action.
Required for 'view' and 'http' actions.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Http
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: View
  Position: Named
  IsRequired: true
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

### System.String. Returns a formatted ntfy action header string.

{{ Fill in the Description }}

## NOTES

See https://docs.ntfy.sh/publish/#actions for more details on ntfy actions.
Project: https://github.com/ptmorris1/NtfyPwsh


## RELATED LINKS

- [](https://ptmorris1.github.io/posts/NtfyPwsh-Examples)
