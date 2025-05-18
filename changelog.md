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
