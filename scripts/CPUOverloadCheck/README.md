# CPUOverloadCheck

## Description

A RouterOS script that periodically measures CPU load multiple times, calculates the average load, and sends an email notification if the average CPU usage exceeds a predefined threshold.

The script includes built-in protection against concurrent executions by using a scheduler with a check for already running instances.

## Requirements

- RouterOS with configured mail sending (SMTP).
- Availability of auxiliary script [SendEmailFunction](../functions/SendEmailFunction/README.md) for sending emails.
- Script access policies: `read`, `write`, `policy`, `test`.
- Make sure your SMTP server allows sending emails from MikroTik.

## Installing the script

### 1. Import the main script

```bash
/import file-name=Script_CPUOverloadCheck.rsc
```

or copy the script contents into a new script via Winbox/WebFig.

### 2. Edit the script configuration

Replace the recipient email address in the script

`:local SendTo "YOUR_NAME@DOMAIN.com"` with your real email address.

Adjust the CPU load threshold (`DeviceAverageLoadThreshold`) and number of measurements (`NumberOfMeasurements`) if needed.

### 3. Import the scheduler script

Import the schedule from `Schedule_CPUOverloadCheck.rsc` or create the scheduler manually as below.

## Scheduler setup

The scheduler runs the CPUOverloadCheck script every 5 minutes and prevents concurrent runs:

```bash
/system scheduler add name=CPUOverloadCheck interval=5m on-event=":local ScriptName \"CPUOverloadCheck\"; :local ScriptRunning [system script job find where script=\$ScriptName]; :if (\$ScriptRunning) do={ :log info \"The script \$ScriptName cannot be run, it is already running (consider increasing interval or reducing measurements)\"; } else={ /system script run \$ScriptName; }" comment="CPU overload check with concurrency protection" policy=read,write,policy,test start-time=startup
```

## Sample email subject and message

```text
Subject: Mikrotik CPU Average Overload: MyRouterName - 75% [01/07/2025 14:35:22]

CPU AR9344 utilization exceeded 70% threshold. Result of 5 CPU load measurements: 68% 72% 78% 76% 84%
```

## Testing the work

Run the script manually in the terminal:

```bash
/system script run CPUOverloadCheck
```

Check logs for script events and notifications:

```bash
/log print where message~"CPUOverloadCheck"
```

## Security

- Limit access to the script and scheduler by assigning proper user rights and policies.
- Use a dedicated and secure mailbox for receiving notifications.

## Support

If you have questions, suggestions or bugs, create an issue in the repository: [GitHub Profile](https://github.com/Hackitect7/routeros-scripts)

Author: Hackitect7

Date: 2025
