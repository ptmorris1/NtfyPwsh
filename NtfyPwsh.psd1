@{
    ModuleVersion   = '0.5.0'
    Guid            = 'aebdf1cd-c1b6-45b6-9326-cad46ac56889'
    CompanyName     = 'Patrick Morris '
    Copyright       = '2025 Patrick Morris'
    Author          = 'Patrick Morris'
    AliasesToExport = '*'
    RootModule      = 'NtfyPwsh.psm1'
    Description     = 'Powershell module to send ntfy notifications.'
    PrivateData     = @{
        PSData = @{
            Tags         = 'Windows', 'NtfyPwsh', 'PowerShell', 'PSEdition_Core', 'Ntfy'
            ProjectURI   = 'https://github.com/ptmorris1/NtfyPwsh'
            LicenseURI   = 'https://github.com/ptmorris1/NtfyPwsh/blob/main/LICENSE'
            ReleaseNotes = @'
# 📅 Changelog

All notable changes to the **NtfyPwsh** module will be documented in this file.

---

## [0.5.0] - 2025-02-01

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
