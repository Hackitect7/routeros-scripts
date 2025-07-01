# The schedule is intended for RouterOS.
# Schedule name: "NotifyUserLoginAttempts"
# Author: Hackitect7
# Year: 2025
# GitHub: https://github.com/Hackitect7/routeros-scripts
# License: MIT
#
# This schedule is designed to periodically run the script "NotifyUserLoginAttempts".
#
# How to apply this scheduler configuration:
#
# 1. Open MikroTik terminal (via Winbox, WebFig, or SSH).
# 2. Copy and paste the scheduler command below into the terminal:

/system scheduler add name=NotifyUserLoginAttempts interval=5m on-event="/system script run NotifyUserLoginAttempts;" comment="Analyze the log account and send login/logout events" policy=read,write,policy,test start-time=startup

# 3. Press [Enter] to execute the command.
#
# After this, the RouterOS scheduler will automatically run the "NotifyUserLoginAttempts" script every 5 minutes.
#
# Scheduler parameters explanation:
#  - name: a friendly name for the scheduler task. Used to identify the task in the scheduler list.
#
#  - interval: how often the script runs (5 minutes here). Can be set to values like 1m, 10m, 1h, etc., depending on how often you want to check logs.
#
#  - on-event: the command executed on each run. In this case, it runs the script named "NotifyUserLoginAttempts".
#
#  - comment: description for easy identification. Helps you or other admins understand what the task does.
#
#  - policy: permissions required for the task to execute. Must include: read, write, policy, and test — otherwise the script may fail to run or access system data.
#
#  - start-time: when the scheduler starts after device boot. "startup" ensures the schedule becomes active as soon as the device finishes booting.
#
# Notes:
# - Make sure the script "NotifyUserLoginAttempts" exists and is correctly configured before applying the scheduler.
# - Check logs (/log print) to verify scheduler execution and troubleshoot if needed.
#
# This setup helps automate monitoring user login/logout events and sending timely email notifications.
