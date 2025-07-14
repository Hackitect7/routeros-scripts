# The script is intended for RouterOS.
# Script name: "CheckChangeExternalAddress"
# Author: Hackitect7
# Year: 2025
# GitHub: https://github.com/Hackitect7/routeros-scripts
# License: MIT
#
# For this script, you need to set the following policies: read, write, policy, test
#
# IMPORTANT:
# In the script, locate the line with the email address:
#     :local SendTo "YOUR_NAME@DOMAIN.com";
# Replace "YOUR_NAME@DOMAIN.com" with your actual email address
# where you want to receive the CPU load alerts from RouterOS.
#
# Without this, the script will not be able to send email notifications properly.
#
# Description:
# This script checks the device's external IP address by querying the ipify API (http://api.ipify.org).
# If the external IP address has changed since the last check, it sends an email notification with details.
#
# Example of the email message text sent:
#
# Subject: Mikrotik INFO: MyRouter [2025-07-14 11:32:00] External IP address has changed.
#
# IP Address Change Notification
#
# Device: MyRouter
# Date: 2025-07-14
# Time: 11:32:00
# New IP Address: 203.0.113.47
# Previous IP Address: 203.0.113.14
#
# This is an automated message.
#
# How to apply:
# 1. Open the MikroTik terminal (Winbox -> New Terminal, or SSH/WebFig terminal).
# 2. Create a new script and paste the entire contents of this file:
#
#    /system script add name=CPUOverloadCheck policy=read,write,policy,test source=...
#
# 3. Ensure that another script named "SendEmailFunction" exists — this script depends on it
#    to send alert emails.
#
# 4. Set up a scheduler to run this script every X minutes or hours depending on your monitoring needs:
#
#    /system scheduler add \
#        name=CheckChangeExternalAddress \
#        interval=5m \
#        on-event="/system script run CheckChangeExternalAddress;" \
#        comment="Check Change External IP address and notify" \
#        policy=read,write,policy,test \
#        start-time=startup
#
# Additional requirements and tips:
#
# 1. SMTP Configuration:
#    Configure SMTP settings correctly under `/tool e-mail`.
#
# 2. Customization:
#    - You can adjust the number of measurements or threshold values for your environment.
#    - You can attach log export or status files if needed (adjust SendEmail call).
#
# 3. Security:
#    Set user permissions and policies cautiously to protect the script from modification.

# Log the start of the script execution
:log info "Script CheckChangeExternalAddress - Started.";

# Global variable to store the current external IP address
:global CurrentIP;

# Fetch the current external IP address from ipify API
:local NewIP ([/tool fetch url=http://api.ipify.org/ as-value output=user] -> "data");

# Check if the external IP address has changed
:if ($NewIP != $CurrentIP) do={

	# Get device info and current datetime
	:local Time [/system clock get time];
	:local Date [/system clock get date];
	:local DeviceName [/system identity get name];

	# Prepare previous IP address text for the message
	:local PreviousIPText;
	:if ($CurrentIP != "") do={
		:set PreviousIPText "Previous IP Address: $CurrentIP";
	} else={
		:set PreviousIPText "Previous IP Address: Not available";
	}

	# Compose email message body with IP details and timestamps
	:local MessageText "IP Address Change Notification

Device: $DeviceName
Date: $Date
Time: $Time
New IP Address: $NewIP
$PreviousIPText

This is an automated message.";

	# Update the global variable with the new IP
	:set CurrentIP $NewIP;

	# Prepare email parameters
	:local SendTo "YOUR_NAME@DOMAIN.com";
	:local Subject "Mikrotik INFO: $DeviceName [$Date $Time] External IP address has changed.";
	:local FileName ""; # No attachment

	# Retrieve the SendEmailFunction script source
	:local SendEmail [:parse [/system script get SendEmailFunction source]];

	# Check if the SendEmailFunction is present, then send the email
	:if ([:typeof $SendEmail] != "nil") do={
		$SendEmail SendTo=$SendTo TextMail=$MessageText Subject=$Subject FileName=$FileName;
	} else={
		:log error "Script SendEmailFunction is missing!";
	}
};

# Log completion of the script execution
:log info "Script CheckChangeExternalAddress - Completed.";
