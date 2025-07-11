# The schedule is intended for RouterOS.
# Schedule name: "CPUOverloadCheck"
# Author: Hackitect7
# Year: 2025
# GitHub: https://github.com/Hackitect7/routeros-scripts
# License: MIT
#
# This schedule is designed to periodically run the script "CPUOverloadCheck" with
# protection against concurrent execution (checks if previous run is finished).
#
# How to apply this scheduler configuration:
#
# 1. Open MikroTik terminal (via Winbox, WebFig, or SSH).
# 2. Copy and paste the scheduler command below into the terminal:

/system scheduler add name=CPUOverloadCheck interval=5m on-event=":local ScriptName \"CPUOverloadCheck\"; :local ScriptRunning [system script job find where script=\$ScriptName]; :if (\$ScriptRunning) do={ :log info \"The script \$ScriptName cannot be run, it is already running (consider increasing interval or reducing measurements)\"; } else={ /system script run \$ScriptName; }" comment="CPU overload check with concurrent run protection" policy=read,write,policy,test start-time=startup

# 3. Press [Enter] to execute the command.
#
# After this, the RouterOS scheduler will automatically run the "CPUOverloadCheck" script every 5 minutes,
# ensuring the script does not run concurrently multiple times.
#
# Scheduler parameters explanation:
#  - name: a friendly name for the scheduler task. Used to identify the task in the scheduler list.
#
#  - interval: how often the script runs (5 minutes here). Can be adjusted depending on your monitoring needs.
#
#  - on-event: the command executed on each run. Contains logic to prevent overlapping script executions.
#
#  - comment: description for easy identification. Helps you or other admins understand what the task does.
#
#  - policy: permissions required for the task to execute. Must include: read, write, policy, and test.
#
#  - start-time: when the scheduler starts after device boot. "startup" ensures the schedule is active after boot.
#
# Notes:
# - Make sure the script "CPUOverloadCheck" exists and is properly configured before applying this scheduler.
# - Check logs (/log print) to verify scheduler execution and for troubleshooting.
# - If you encounter frequent concurrent run warnings, consider increasing the interval or reducing the number of measurements.
#
# This setup helps automate monitoring CPU usage and sends email alerts when the average CPU load exceeds a defined threshold.
