# CheckChangeExternalAddress

## Description

A RouterOS script that monitors the external IP address by querying [ipify.org](http://api.ipify.org). If the IP changes, it sends an email notification with the new and previous IP addresses.

This script is useful for:

- Monitoring public IP changes in dynamic IP environments.
- Triggering alerts for DDNS updates or remote access awareness.

## Requirements

- RouterOS with internet access and DNS resolution.
- RouterOS with configured mail sending (SMTP).
- The supporting function script [SendEmailFunction](../../functions/SendEmailFunction/) must be imported and configured.
- Script access policies: `read`, `write`, `policy`, `test`.

## How it works

1. Fetches the current public IP from `http://api.ipify.org`.
2. Compares it with the previously stored IP (`global CurrentIP`).
3. If changed — updates the variable and sends an email notification.

## Installing the script

### 1. Import the main script

```bash
/import file-name=Script_CheckChangeExternalAddress.rsc
```

or copy the script contents into a new script via Winbox/WebFig.

### 2. Configure email recipient

Edit this line in the script:

```mikrotik
:local SendTo "YOUR_NAME@DOMAIN.com";
```

### 3. Ensure that the SendEmailFunction is imported and configured properly

## Scheduler setup

Run the script periodically to detect changes. Use the scheduler provided in the file `Schedule_CheckChangeExternalAddress.rsc` or create manually:

```bash
/system scheduler add name=CheckChangeExternalAddress interval=5m on-event="/system script run CheckChangeExternalAddress;" comment="Check Change External IP address and notify" policy=read,write,policy,test start-time=startup
```

## Sample email subject and message

```text
Subject: Mikrotik INFO: MyRouter [2025-07-14 11:32:00] External IP address has changed.

IP Address Change Notification

Device: MyRouter
Date: 2025-07-14
Time: 11:32:00
New IP Address: 203.0.113.47
Previous IP Address: 203.0.113.14

This is an automated message.
```

## Troubleshooting

- Make sure your firewall allows outbound HTTP (TCP 80) for API request to `http://api.ipify.org`.
- SMTP must be correctly configured in /tool e-mail.
- Use logs to trace issues:

```bash
/log print where message~"CheckChangeExternalAddress"
```

- You can run the script manually:

```bash
/system script run CheckChangeExternalAddress
```

## Security

- Limit access to the script and scheduler by assigning proper user rights and policies.
- Use a dedicated and secure mailbox for receiving notifications.

## Support

If you have questions, suggestions or bugs, create an issue in the repository: [GitHub Profile](https://github.com/Hackitect7/routeros-scripts)

Author: [Hackitect7](https://github.com/Hackitect7)

Date: 2025
