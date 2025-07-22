# CreateBackupAndSendEmail

## Description

A RouterOS script that creates a backup of the device configuration and exports the configuration to an `.rsc` file.  
It then sends an email with the encrypted backup file attached and includes detailed information in the message body.

## Requirements

- RouterOS with configured mail sending (SMTP).  
- Availability of auxiliary script [SendEmailFunction](../../functions/SendEmailFunction/) for sending emails.  
- Script access policies: `ftp`, `read`, `write`, `policy`, `test`, `sensitive`.  
- Make sure your SMTP server allows sending emails from MikroTik.  

## Installing the script

### 1. Import the main script

```bash
/import file-name=Script_CreateBackupAndSendEmail.rsc
```

or copy the script contents into a new script via Winbox/WebFig.

### 2. Edit the script configuration

Replace in the script:

- The recipient email address `:local SendTo "YOUR_NAME@DOMAIN.com"` with your real email address.
- The backup file password `:local Password "YOUR_BACKUP_ARCHIVE_PASSWORD"` with your desired secure password.

> **Backup Password Note:**  
> The `password` field in the backup command is optional. However, **it is highly recommended to set a strong password** to prevent unauthorized restoration of the configuration on other MikroTik devices.
>
> ⚠️ **Important:** The archive is **not encrypted for secure transmission**. If you transfer the backup over unsecured channels (such as plain FTP or non-TLS email), it may be intercepted. The password protects the archive from being restored on another device, but does **not** fully encrypt the content for confidentiality. For highly sensitive setups, consider manual encryption before transmission.

### 3. Import the scheduler script

Import the schedule from `Schedule_CreateBackupAndSendEmail.rsc` or create the scheduler manually as shown below.

## Scheduler setup

The scheduler runs the `CreateBackupAndSendEmail` script once a week at the configured time:

```bash
/system scheduler add name=CreateBackupAndSendEmail interval=1w on-event="/system script run CreateBackupAndSendEmail" comment="Create backup and send it by email weekly" policy=ftp,read,write,policy,test,sensitive start-date=2024-08-10 start-time=00:10:00
```

## Sample email subject and message

```text
Subject: Mikrotik BACKUP: MyRouterName [01/07/2025 00:10:00]

Device Backup Notification

Device Name: MyRouterName
Date: 01/07/2025
Time: 00:10:00
Backup File: MyRouterName.backup
Configuration File (.rsc) also created on the device: MyRouterName.rsc

This is an automated message.
```

## Testing the work

Run the script manually in the terminal:

```bash
/system script run CreateBackupAndSendEmail
```

Check logs for script events and notifications:

```bash
/log print where message~"CreateBackupAndSendEmail"
```

## Security

- Protect the backup password and ensure it is strong to prevent unauthorized access.
- Limit access to the script and scheduler by assigning proper user rights and policies.
- Use a dedicated and secure mailbox for receiving backup notifications.

## Support

If you have questions, suggestions or bugs, create an issue in the repository: [GitHub Profile](https://github.com/Hackitect7/routeros-scripts)

Author: [Hackitect7](https://github.com/Hackitect7)

Date: 2025
