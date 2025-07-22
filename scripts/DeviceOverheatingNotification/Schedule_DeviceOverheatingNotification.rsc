# The schedule is intended for RouterOS.
# Schedule name: "DeviceOverheatingNotification"
# Author: Hackitect7
# Year: 2025
# GitHub: https://github.com/Hackitect7/routeros-scripts
# License: MIT
#
# This schedule is designed to periodically run the script "DeviceOverheatingNotification"
# to monitor CPU temperature and send a critical alert email if the temperature exceeds the defined threshold.
#
# How to apply this scheduler configuration:
#
# 1. Open MikroTik terminal (via Winbox, WebFig, or SSH).
# 2. Copy and paste the scheduler command below into the terminal:

/system scheduler add name=DeviceOverheatingNotification interval=5m on-event="/system script run DeviceOverheatingNotification" comment="Device overheating notification" policy=read,write,policy,test start-time=startup

# 3. Press [Enter] to execute the command.
#
# After this, the RouterOS scheduler will automatically run the "DeviceOverheatingNotification" script every 5 minutes,
# checking the CPU temperature and sending an email alert if it exceeds the configured maximum.
#
# Scheduler parameters explanation:
#  - name: a friendly name for the scheduler task. Used to identify the task in the scheduler list.
#
#  - interval: how often the script runs (5 minutes here). Can be adjusted based on monitoring needs.
#
#  - on-event: the command executed on each run. Simply runs the script.
#
#  - comment: description for easy identification. Helps you or other admins understand what the task does.
#
#  - policy: permissions required for the task to execute. Must include: read, write, policy, and test.
#
#  - start-time: when the scheduler starts after device boot. "startup" ensures the schedule is active after boot.
#
# Notes:
# - Make sure the script "DeviceOverheatingNotification" exists and is properly configured before applying this scheduler.
# - Check logs (/log print) to verify scheduler execution and for troubleshooting.
#
# This setup helps automate monitoring of device temperature and notifies administrators promptly in case of overheating.
