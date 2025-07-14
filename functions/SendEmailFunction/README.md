# 📧 SendEmailFunction

A reusable function for sending email notifications from MikroTik RouterOS via SMTP.  
Designed to be called from other scripts (e.g., login monitoring, alerts, backups).

---

## 📄 Script Info

- **Script Name:** `SendEmailFunction`
- **Author:** [Hackitect7](https://github.com/Hackitect7)
- **Year:** 2025  
- **License:** [MIT](../../LICENSE)
- **GitHub:** [https://github.com/Hackitect7/routeros-scripts](https://github.com/Hackitect7/routeros-scripts)

---

## ⚙️ Purpose

This function allows you to send an email with optional attachment from a MikroTik device using built-in `/tool e-mail send`.  
It supports TLS (port 465), external SMTP (e.g., Gmail, Yandex, Outlook), and is intended to be embedded into other scripts.

---

## 🔐 Configuration Required

Inside the script, **you must manually set** the following values before use:

| Variable              | Description                                           |
|-----------------------|-------------------------------------------------------|
| `SENDER_NAME@DOMAIN.com` | The actual email address used as sender and SMTP login. |
| `SENDER_PASSWORD`     | The SMTP password or app-password.                   |
| `SENDER_SMTP_SERVER`  | SMTP server domain (e.g., `smtp.gmail.com`).         |
| `465`                 | SMTP port. You can change if needed (e.g., `587`).   |

📌 **Important**:

- Ensure SMTP credentials are valid and the account allows SMTP access.
- Gmail/Outlook may require an **App Password** or enabling access for "less secure apps".
- Your MikroTik must allow outbound connections on the chosen port (default: 465).

---

## 🔐 Script Permissions

- Set `"Don't Require Permissions"` ✅ for this script in RouterOS.
- **Do not check** any policy checkboxes — it will inherit permissions from the caller script.

---

## 🧩 How to Use

This script must be **called from another script**, not run directly.

### Example

```mikrotik
:local SendEmail [:parse [/system script get SendEmailFunction source]];
$SendEmail SendTo="admin@example.com" TextMail="Login alert!" Subject="Router Login" FileName=""
```

### Variables expected by the function

| Variable    | Description                                     |
|-------------|-------------------------------------------------|
| `$SendTo`   | Recipient's email address                       |
| `$Subject`  | Subject line of the email                       |
| `$TextMail` | Body text of the email                          |
| `$FileName` | Optional file to attach (leave blank if unused) |

## 🛠 Troubleshooting

- Check logs in /log print if no email is received.
- Ensure your MikroTik device has a valid DNS and gateway.
- Use /tool e-mail manually to test if SMTP credentials work.

## 🧪 Tested With

- RouterOS 7.x
- Gmail SMTP (via app-password)
- Yandex SMTP
- Outlook SMTP

## 📦 Related

NotifyUserLoginAttempts — Script that uses this function to alert on login/logout events.

## 📬 Feedback & Contributions

Feel free to submit suggestions or improvements via GitHub.
This is an open-source script under MIT license.
