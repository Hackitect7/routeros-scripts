# CheckUpdate

## Description

A RouterOS script that checks daily for available RouterOS package updates and sends an email notification if a new version is found.

This script helps administrators stay informed about new RouterOS versions to keep devices up to date and secure.

## Requirements

- RouterOS with configured mail sending (SMTP).
- Availability of auxiliary script [SendEmailFunction](../../functions/SendEmailFunction/) for sending emails.
- Script access policies: `read`, `write`, `policy`, `test`.
- Ensure your SMTP server allows sending emails from MikroTik.

## Installing the script

### 1. Import the main script

```bash
/import file-name=Script_CheckUpdate.rsc
```

or copy the script contents into a new script via Winbox/WebFig.

### 2. Edit the script configuration

Replace the recipient email address in the script

`:local SendTo "YOUR_NAME@DOMAIN.com"` with your real email address.

### 3. Import the scheduler script

Import the schedule from Schedule_CheckUpdate.rsc or create the scheduler manually as shown below.

## Scheduler setup

The scheduler runs the CheckUpdate script once daily at a set time:

```bash
/system scheduler add name=CheckUpdate interval=1d start-date=2024-08-10 start-time=15:00:00 on-event="/system script run CheckUpdate" comment="Runs CheckUpdate script once daily" policy=read,write,policy,test
```

## Sample email subject and message

```text
Subject: Mikrotik UPDATE: MyRouterName [01/07/2025 15:00:00]

A new RouterOS version 7.10 is available!

Installed version: 7.9
Channel: stable

Changelogs: https://mikrotik.com/download/changelogs

This is an automated message.
```

## Testing the work

Run the script manually in the terminal:

```bash
/system script run CheckUpdate
```

Check logs for script events and notifications:

```bash
/log print where message~"CheckUpdate"
```

## Security

- Limit access to the script and scheduler by assigning proper user rights and policies.
- Use a dedicated and secure mailbox for receiving notifications.

## Support

If you have questions, suggestions or bugs, create an issue in the repository: [GitHub Profile](https://github.com/Hackitect7/routeros-scripts)

Author: [Hackitect7](https://github.com/Hackitect7)

Date: 2025
