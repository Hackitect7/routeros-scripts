# 🔧 Scripts

Automation scripts that perform independent actions in RouterOS.

---

## 📜 Available Scripts

- [NotifyUserLoginAttempts](./NotifyUserLoginAttempts/)  
  Monitors login/logout activity and sends alerts by email.
- [CPUOverloadCheck](./CPUOverloadCheck/)  
  Measures CPU load multiple times, calculates average usage, and sends an email alert if the load exceeds a set threshold.

- [CheckChangeExternalAddress](./CheckChangeExternalAddress/)  
  Checks the router’s external IP address using ipify.org and sends a notification email if the IP address has changed.

- [CheckUpdate](./CheckUpdate/)  
  Checks daily for new RouterOS updates and sends an email notification if a new version is available.

- [CreateBackupAndSendEmail](./CreateBackupAndSendEmail/)  
  Creates a secure backup of the router configuration and emails it as an attachment. Optionally password-protected. Without a password, the backup is transmitted in unencrypted form, which may pose a security risk. Designed to be used with the built-in `SendEmailFunction`.

(More scripts coming soon...)
