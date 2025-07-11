# 📡 MikroTik RouterOS Scripts Collection

A structured and modular collection of MikroTik RouterOS scripts and functions for automation, logging, email notifications, and network management.

---

## 📁 Contents

The repository is organized into logical groups of scripts and reusable functions.

Each group folder contains its own `README.md` with detailed descriptions and setup instructions for included scripts.

---

### 🔧 [Scripts](./scripts/README.md)

Automation scripts for monitoring, notifications, and other system tasks.

| Script              | Description       |
| ------------------- | ----------------- |
| [`NotifyUserLoginAttempts`](./scripts/NotifyUserLoginAttempts/README.md) | Monitors RouterOS logs for user login/logout events (`account` topic) and sends an email alert when new entries are detected. Designed to run periodically via the scheduler. |
| [`CPUOverloadCheck`](./scripts/CPUOverloadCheck/README.md)               | Measures CPU load multiple times, calculates average usage, and sends an email alert if the load exceeds a defined threshold. Runs via scheduled tasks.                     |

---

### 🧩 [Functions](./functions/README.md)

Reusable functions designed to be called from other scripts (e.g. email sending, parsing, etc).

| Function            | Description       |
| ------------------- | ----------------- |
| [`SendEmailFunction`](./functions/SendEmailFunction/README.md) | General-purpose SMTP email sender. Called from other scripts to send notifications via external mail servers (supports TLS, attachments, and app passwords). Not intended to be run directly. |

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
