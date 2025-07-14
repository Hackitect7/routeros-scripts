# The schedule is intended for RouterOS.
# Schedule name: "CheckChangeExternalAddress"
# Author: Hackitect7
# Year: 2025
# GitHub: https://github.com/Hackitect7/routeros-scripts
# License: MIT
#
# This schedule is designed to periodically run the script "CheckChangeExternalAddress".
#
# How to apply this scheduler configuration:
#
# 1. Open MikroTik terminal (via Winbox, WebFig, or SSH).
# 2. Copy and paste the scheduler command below into the terminal:

/system scheduler add name=CheckChangeExternalAddress interval=5m on-event="/system script run CheckChangeExternalAddress;" comment="Check Change External IP address and notify" policy=read,write,policy,test start-time=startup

# 3. Press [Enter] to execute the command.
#
# After this, RouterOS will automatically run the "CheckChangeExternalAddress" script every 5 minutes.
#
# Scheduler parameters explanation:
#  - name: a friendly name for the scheduler task. Used to identify the task in the scheduler list.
#
#  - interval: how often the script runs (5 minutes here). Can be adjusted depending on your needs.
#
#  - on-event: the command executed on each run.
#
#  - comment: description for easy identification.
#
#  - policy: permissions required for the task to execute. Must include: read, write, policy, and test.
#
#  - start-time: ensures the schedule becomes active after device boot.
#
# Notes:
# - Make sure the script "CheckChangeExternalAddress" exists and is configured correctly.
# - Check logs (/log print) to verify scheduler execution and troubleshoot if needed.
#
# This setup helps automate monitoring of public IP address changes and sends alerts if the address changes.
