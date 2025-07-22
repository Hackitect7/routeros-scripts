# DeviceOverheatingNotification

## Description

A RouterOS script that monitors the temperature of MikroTik devices (with `/system health` support) and sends an email notification when the temperature exceeds a predefined threshold.  

The script is designed to run periodically via the scheduler and includes basic safeguards to ensure accuracy of notification.  

## Requirements

- RouterOS with `/system health` command available.
- Configured SMTP for email sending.
- Presence of auxiliary script [SendEmailFunction](../../functions/SendEmailFunction/) used for email delivery.
- Script access policies: `read`, `write`, `policy`, `test`.

## Installing the script

### 1. Import the main script

```bash
/import file-name=Script_DeviceOverheatingNotification.rsc
```

or copy the script contents into a new script via Winbox/WebFig.

### 2. Edit the script configuration

Open the script and edit the following lines:

```bash
:local TemperatureThreshold 70
:local SendTo "YOUR_NAME@DOMAIN.com"
```

Replace the email with your real address and adjust the temperature threshold (°C) if needed.

### 3. Import the scheduler script

To schedule periodic temperature checks, import `Schedule_DeviceOverheatingNotification.rsc` or create a scheduler manually (e.g., every 5 minutes):

## Scheduler setup

The scheduler runs the DeviceOverheatingNotification script every 5 minutes:

```bash
/system scheduler add name=DeviceOverheatingNotification interval=5m on-event="/system script run DeviceOverheatingNotification" comment="Check for device overheating" policy=read,write,policy,test start-time=startup
```

## Sample email subject and message

```text
Critical Alert!

Device: YOUR_DEVICE_NAME
Temperature: 75 °C
CPU Load: 70 %

This is an automated message.
```

## Testing the work

Run the script manually in the terminal:

```bash
/system script run DeviceOverheatingNotification
```

Check logs for script events and notifications:

```bash
/log print where message~"DeviceOverheatingNotification"
```

## Security

- Limit access to the script and scheduler by assigning proper user rights and policies.
- Use a dedicated and secure mailbox for receiving notifications.

## Support

If you have questions, suggestions or bugs, create an issue in the repository: [GitHub Profile](https://github.com/Hackitect7/routeros-scripts)

Author: [Hackitect7](https://github.com/Hackitect7)

Date: 2025
