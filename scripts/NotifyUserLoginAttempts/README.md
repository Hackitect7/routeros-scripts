
# NotifyUserLoginAttempts

## Description

A script for RouterOS that analyzes the system log for user login/logout events (topic "account") and sends email notifications when new events are detected.

## Requirements

- RouterOS with configured mail sending (SMTP).
- Availability of auxiliary script [SendEmailFunction](../functions/SendEmailFunction/SendEmailFunction.rsc) for sending emails.
- Script access policies: `read`, `write`, `policy`, `test`.

## Installing the script

### 1. Import the main script

```bash
/import file-name=Script_NotifyUserLoginAttempts.rsc
```

Or copy the contents of `Script_NotifyUserLoginAttempts.rsc` into a new script via Winbox/WebFig.

### 2. Check and edit the email address in the script

`:local SendTo "YOUR_NAME@DOMAIN.com";`

Replace `YOUR_NAME@DOMAIN.com` with your real email address.

### 3. Make sure the SendEmailFunction script is loaded and configured

## Scheduler setup

Import the schedule from `Schedule_NotifyUserLoginAttempts.rsc` or create a task manually:

```bash
/system scheduler add name=NotifyUserLoginAttempts interval=5m on-event="/system script run NotifyUserLoginAttempts;" comment="Login log monitoring" policy=read,write,policy,test start-time=startup
```

## Sample email message

```text
Subject: AUTH: MyRouterName [01/07/2025 14:35:22]

User Login Attempt Notification

14:20:15 - login attempt for user admin;
14:22:10 - login failed for user guest;
14:25:05 - logged out user admin;

This is an automated message.
```

## Testing the work

Run the script manually from the terminal:

```bash
/system script run NotifyUserLoginAttempts
```

View the logs:

```bash
/log print where message~"NotifyUserLoginAttempts"
```

## Security

- Limit access to scripts and schedules by assigning the appropriate rights.
- Use a unique and secure mailbox.

## Support

If you have questions, suggestions or bugs, create an issue in the repository: [GitHub Profile](https://github.com/Hackitect7/routeros-scripts)

Author: [Hackitect7](https://github.com/Hackitect7)

Date: 2025
