@{
    ModuleVersion   = '0.3.0'
    Guid            = 'aebdf1cd-c1b6-45b6-9326-cad46ac56889'
    CompanyName     = 'Patrick Morris '
    Copyright       = '2025 Patrick Morris'
    Author          = 'Patrick Morris'
    AliasesToExport = '*'
    RootModule      = 'NtfyPwsh.psm1'
    Description     = 'Powershell module to send ntfy notifications.'
    #FormatsToProcess = 'PSSVG.format.ps1xml'
    PrivateData     = @{
        PSData = @{
            Tags         = 'Windows', 'NtfyPwsh', 'PowerShell', 'PSEdition_Core', 'Ntfy'
            ProjectURI   = 'https://github.com/ptmorris1/NtfyPwsh'
            LicenseURI   = 'https://github.com/ptmorris1/NtfyPwsh/blob/main/LICENSE'
            ReleaseNotes = @'
### NtfyPwsh 0.1.0
* Initial Release of NtfyPwsh
  * Used to send notifications to ntfy from PowerShell in a Module!
---
### NtfyPwsh 0.2.0
* Added default parameter set.
* Fixed some parameter set issues.
---
### NtfyPwsh 0.3.0
* Fixed tags parameter
  * Updated tag value 'partying_face'
---
'@
        }
    }
}
