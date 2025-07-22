# The schedule is intended for RouterOS.
# Schedule name: "CreateBackupAndSendEmail"
# Author: Hackitect7
# Year: 2025
# GitHub: https://github.com/Hackitect7/routeros-scripts
# License: MIT
#
# This schedule is designed to periodically run the script "CreateBackupAndSendEmail"
# to create a backup of the device configuration and send it by email.
#
# How to apply this scheduler configuration:
#
# 1. Open MikroTik terminal (via Winbox, WebFig, or SSH).
# 2. Copy and paste the scheduler command below into the terminal:

/system scheduler add name=CreateBackupAndSendEmail interval=1w on-event="/system script run CreateBackupAndSendEmail" comment="Create backup and send it by email weekly" policy=ftp,read,write,policy,test,sensitive start-date=2024-08-10 start-time=00:10:00

# 3. Press [Enter] to execute the command.
#
# After this, the RouterOS scheduler will automatically run the "CreateBackupAndSendEmail" script once a week,
# creating a backup and emailing it according to the configured schedule.
#
# Scheduler parameters explanation:
#  - name: a friendly name for the scheduler task. Used to identify the task in the scheduler list.
#
#  - interval: how often the script runs (1 week here). Can be adjusted depending on your backup policy.
#
#  - on-event: the command executed on each run. Here it runs the "CreateBackupAndSendEmail" script.
#
#  - comment: description for easy identification. Helps you or other admins understand what the task does.
#
#  - policy: permissions required for the task to execute. Must include: ftp, read, write, policy, test, and sensitive,
#    since the script saves backups and sends email with attachments.
#
#  - start-date: the date from which the schedule is active.
#
#  - start-time: the time of day when the schedule triggers the first run.
#
# Notes:
# - Ensure the script "CreateBackupAndSendEmail" exists and is properly configured before applying this scheduler.
# - Check logs (/log print) to verify scheduler execution and for troubleshooting.
# - Ensure sufficient disk space is available for backups on the device.
#
# This setup helps automate weekly backup creation and emailing for RouterOS devices.
