@{
    ModuleVersion   = '1.1.0'
    Guid            = 'aebdf1cd-c1b6-45b6-9326-cad46ac56889'
    CompanyName     = 'Patrick Morris '
    Copyright       = '24-2025 Patrick Morris'
    Author          = 'Patrick Morris'
    AliasesToExport = '*'
    RootModule      = 'NtfyPwsh.psm1'
    Description     = 'Powershell module to send ntfy notifications.'
    PrivateData     = @{
        PSData = @{
            Tags         = 'Windows', 'NtfyPwsh', 'PowerShell', 'PSEdition_Core', 'Ntfy', 'linux'
            ProjectURI   = 'https://github.com/ptmorris1/NtfyPwsh'
            LicenseURI   = 'https://github.com/ptmorris1/NtfyPwsh/blob/main/LICENSE'
            ReleaseNotes = @'
# 📅 Changelog

All notable changes to the **NtfyPwsh** module will be documented in this file.

---

## [1.1.0] - 2025-07-27

### Changed

* Moved functions to their own `.ps1` files for better modularity and maintainability.
* Removed `examples.md` and now use the blog post as the primary location for all examples.

### Added

* Added `mkdocs` documentation support for the project.

---

## [1.0.1] - 2025-05-21

### Updated

* Updated comment-based help in the module.
* Tested on Linux.

### Linux Known Issues

* `-Delay` parameter does not work.
* `-Email` sends message to ntfy but does not send email.

---

## [1.0.0] - 2025-05-20

### Release

* First official release of NtfyPwsh.  

### Added

* Added `-Markdown` parameter to `Send-NtfyMessage` to enable Markdown formatting in notifications.
* Added `Write-Verbose` statements for debugging headers and payloads sent to the server.
* Added `-FirebaseNo` parameter to `Send-NtfyMessage` to avoid forwarding messages to FirebaseCloudMessaging (if configured)

---

## [0.6.0] - 2025-05-19

### Changed

* The `-Action` parameter in `Send-NtfyMessage` was removed and replaced with the parameters `-ActionView`, `-ActionHttp`, and `-ActionBroadcast` for building actions using `Build-NtfyAction`.
* ⚠️ **Breaking:** You must now use `Build-NtfyAction` with the new action type parameters to construct actions for `Send-NtfyMessage`.

### Removed

* The `-Action` parameter from `Send-NtfyMessage` has been removed. Use `Build-NtfyAction` with the new action type parameters instead.

### Fixed

* Parameter sets now more strictly enforce Ntfy requirements for each action.

### Added

* Added -NoCache Parameter to `Send-NtfyMessage` to prevent the message from being cached server-side

---

## [0.5.0] - 2025-05-18

### Fixed

* Fixed and updated parameter sets.

### Updated

* Updated docs with examples and more detail.
* Updated comment-based help in module.

---

## [0.4.0] - 2025-01-01

### Breaking

* Authentication method changed:
  * Now uses `-TokenCreds` for API using `Get-Credential`.
  * Now uses `-Credential` for username and password using `Get-Credential`.
  * Removed `-PlainTextToken`.

---

## [0.3.0] - 2024-12-01

### Fixed

* Fixed `tags` parameter.
  * Updated tag value to `'partying_face'`.

---

## [0.2.0] - 2024-11-01

### Added

* Default parameter set.

### Fixed

* Parameter set issues.

---

## [0.1.0] - 2024-10-01

### Initial Release

* Initial release of NtfyPwsh.
  * Used to send notifications to ntfy from PowerShell in a module.

---

> 📌 This changelog follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) principles.

'@
        }
    }
}

