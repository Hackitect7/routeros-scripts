# The schedule is intended for RouterOS.
# Schedule name: "CheckUpdate"
# Author: Hackitect7
# Year: 2025
# GitHub: https://github.com/Hackitect7/routeros-scripts
# License: MIT
#
# This schedule is designed to periodically run the script "CheckUpdate" once per day.
#
# How to apply this scheduler configuration:
#
# 1. Open MikroTik terminal (via Winbox, WebFig, or SSH).
# 2. Copy and paste the scheduler command below into the terminal:

/system scheduler add name=CheckUpdate interval=1d start-date=2024-08-10 start-time=15:00:00 on-event="/system script run CheckUpdate" comment="Runs CheckUpdate script" policy=read,write,policy,test

# 3. Press [Enter] to execute the command.
#
# After this, the RouterOS scheduler will automatically run the "CheckUpdate" script once per day at 15:00.
#
# Scheduler parameters explanation:
#  - name: friendly identifier of the scheduler task.
#  - interval: frequency of execution (1 day).
#  - start-date / start-time: exact start moment for scheduling.
#  - on-event: command to run. This one executes the script "CheckUpdate".
#  - comment: description for clarity and administration purposes.
#  - policy: required permissions to execute the script.
#
# Notes:
# - Ensure that the script "CheckUpdate" exists and is working properly before applying this scheduler.
# - You can view scheduled tasks using: /system scheduler print
# - Logs (/log print) will help verify execution and troubleshooting.
#
# This setup helps automate the check for RouterOS updates and can be extended to notify via email or log entries.
