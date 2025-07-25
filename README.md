# 📡 MikroTik RouterOS Scripts Collection

A structured and modular collection of MikroTik RouterOS scripts and functions for automation, logging, email notifications, and network management.

---

## 📁 Contents

The repository is organized into logical groups of scripts and reusable functions.

Each group folder contains its own `README.md` with detailed descriptions and setup instructions for included scripts.

---

### 🔧 [Scripts](./scripts/)

Automation scripts for monitoring, notifications, and other system tasks.

| Script              | Description       |
| ------------------- | ----------------- |
| [`NotifyUserLoginAttempts`](./scripts/NotifyUserLoginAttempts/) | Monitors RouterOS logs for user login/logout events (`account` topic) and sends an email alert when new entries are detected. Designed to run periodically via the scheduler. |
| [`CPUOverloadCheck`](./scripts/CPUOverloadCheck/)               | Measures CPU load multiple times, calculates average usage, and sends an email alert if the load exceeds a defined threshold. Runs via scheduled tasks.                       |
| [`CheckChangeExternalAddress`](./scripts/CheckChangeExternalAddress/) | Monitors the router's external IP address using `ipify.org`. Sends an email alert if the external IP has changed since the last check.                                  |
| [`CheckUpdate`](./scripts/CheckUpdate/) | Checks daily for new RouterOS updates and sends an email notification if a new version is available. |
| [`CreateBackupAndSendEmail`](./scripts/CreateBackupAndSendEmail/) | Creates a RouterOS configuration backup (optionally encrypted with a password), then emails it as an attachment to a specified address. Note: if no password is set, the backup will be sent unencrypted over the internet. |
| [`DeviceOverheatingNotification`](./scripts/DeviceOverheatingNotification/) | Monitors system temperature using RouterOS sensors and sends an email alert if the value exceeds a defined threshold. Useful for preventing hardware damage in hot environments. |

---

### 🧩 [Functions](./functions/)

Reusable functions designed to be called from other scripts (e.g. email sending, parsing, etc).

| Function            | Description       |
| ------------------- | ----------------- |
| [`SendEmailFunction`](./functions/SendEmailFunction/) | General-purpose SMTP email sender. Called from other scripts to send notifications via external mail servers (supports TLS, attachments, and app passwords). Not intended to be run directly. |

---

## 📄 License

This project is released under the [MIT License](./LICENSE).

---

## 👤 Author

**Hackitect7**  
[GitHub Profile](https://github.com/Hackitect7/routeros-scripts)

---

## 🙌 Contributions

Suggestions, improvements, and PRs are welcome.  
Feel free to fork this project and adapt it for your own use.
