# The script is intended for RouterOS.
# Script name: "CheckUpdate"
# Author: Hackitect7
# Year: 2025
# GitHub: https://github.com/Hackitect7/routeros-scripts
# License: MIT
#
# For this script, you need to set the following policies: read
#
# IMPORTANT:
# In the script, locate the line with the email address:
#     :local SendTo "YOUR_NAME@DOMAIN.com";
# Replace it with your own email address where you'd like to receive update notifications.
#
# Description:
# This script checks for RouterOS updates via the built-in package update tool.
# If a new version is available, it sends an email notification containing update details.
#
# The script compares the currently installed version with the latest available one
# and logs the result. If an update is available, an alert is sent automatically.
#
# Example of the email message text sent:
#
# Subject: Mikrotik UPDATE: MyRouter [01/08/2025 15:00:00]
#
# A new RouterOS version 7.15 is available!
#
# Installed version: 7.13.5
# Channel: stable
#
# Changelogs: https://mikrotik.com/download/changelogs
#
# This is an automated message.
#
# How to apply:
# 1. Open the MikroTik terminal (Winbox -> New Terminal, or SSH/WebFig terminal).
# 2. Create a new script and paste the full content of this file:
#
#    /system script add name=CheckUpdate policy=read source=...
#
# 3. Ensure that another script named "SendEmailFunction" exists — this script depends on it
#    to send alert emails.
#
# 4. Set up a scheduler to run this script once a day:
#
#    /system scheduler add \
#        name=CheckUpdate \
#        interval=1d \
#        start-date=2024-08-10 \
#        start-time=15:00:00 \
#        on-event="/system script run CheckUpdate" \
#        comment="Check Update" \
#        policy=read,write,policy,test
#
# Additional requirements and tips:
#
# 1. SMTP Configuration:
#    Configure SMTP settings correctly under `/tool e-mail` before using email functionality.
#
# 2. Security:
#    Grant script users only necessary permissions. Use a dedicated script user if needed.
#
# 3. RouterOS Version:
#    Ensure your device supports the required commands in your RouterOS version.

# Log the start of the script
:log info "Script CheckUpdate - Started.";

# Get the device name
:local DeviceName [/system identity get name];
# Get the current date and time
:local Date [/system clock get date];
:local Time [/system clock get time];

# Retrieve update info
:local CheckUpdate [/system package update check-for-updates as-value];
:local Channel ($CheckUpdate -> "channel");
:local InstalledVersion ($CheckUpdate -> "installed-version");
:local LatestVersion ($CheckUpdate -> "latest-version");

# Compare versions
:if ($InstalledVersion != $LatestVersion) do={

    # Prepare email message text
    :local EmailMessageText "A new RouterOS version $LatestVersion is available!

Installed version: $InstalledVersion
Channel: $Channel

Changelogs: https://mikrotik.com/download/changelogs

This is an automated message.";

    # Log update event
    :log info "Script CheckUpdate - New version available, sending notification.";

    # Send Email
    :local SendTo "YOUR_NAME@DOMAIN.com";
    :local Subject "Mikrotik UPDATE: $DeviceName [$Date $Time]";
    :local SendText $EmailMessageText;
    :local FileName "";

    # Retrieve the SendEmail function
    :local SendEmail [:parse [/system script get SendEmailFunction source]];
    $SendEmail SendTo=$SendTo TextMail=$SendText Subject=$Subject FileName=$FileName;

} else={
    :log info "Script CheckUpdate - System is already up to date.";
}

# Short delay before exit
:delay 1;

# Log completion
:log info "Script CheckUpdate - Completed.";
