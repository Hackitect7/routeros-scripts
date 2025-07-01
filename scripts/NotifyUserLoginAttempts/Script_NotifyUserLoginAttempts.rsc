# The script is intended for RouterOS.
# Script name: "NotifyUserLoginAttempts"
# Author: Hackitect7
# Year: 2025
# GitHub: https://github.com/Hackitect7/routeros-scripts
# License: MIT
#
# For this script, you need to set the following policies: read, write, policy, test
#
# IMPORTANT:
# In the script, locate the line with the email address:
#    :local SendTo "YOUR_NAME@DOMAIN.com";
# Replace "YOUR_NAME@DOMAIN.com" with your actual email address
# where you want to receive the notification emails from RouterOS.
#
# Without this, the script will not be able to send email notifications properly.
#
# Description:
# This script analyzes the system log for user login and logout events (topic "account"),
# and sends an email notification when new events are found.
#
# Example of the email message text sent:
#
# Subject: AUTH: MyRouterName [01/07/2025 14:35:22]
#
# User Login Attempt Notification
#
#    14:20:15 - login attempt for user admin;
#    14:22:10 - login failed for user guest;
#    14:25:05 - logged out user admin;
#
# This is an automated message.
#
# This example helps you understand the format of notifications you will receive.
#
# How to apply:
# 1. Open the MikroTik terminal (`Winbox → New Terminal`, or SSH/WebFig terminal).
# 2. Create a new script and paste the entire contents of this file.
#    You can do it with the following command:
#
#    /system script add name=NotifyUserLoginAttempts policy=read,write,policy,test source=...
#
#    ⛔ NOTE: If you're using CLI, it's better to paste the script body inside Winbox/WebFig UI 
#    under `System → Scripts`, to avoid syntax issues in terminal.
#
# 3. Ensure that another script named "SendEmailFunction" exists — this script depends on it
#    to actually send emails.
#
# 4. Set up a scheduler to run this script every 5 minutes:
#
#    /system scheduler add name=NotifyUserLoginAttempts interval=5m \
#    on-event="/system script run NotifyUserLoginAttempts;" \
#    comment="Analyze the log account and send login/logout events" \
#    policy=read,write,policy,test start-time=startup
#
# After this, the script will automatically check the logs and send alerts if needed.
#
# Additional requirements and recommendations:
#
# 1. SMTP configuration:
#    Ensure that the MikroTik device has a properly configured SMTP client
#    (Settings found in /tool e-mail).
#    Without correct SMTP setup, the script will not be able to send email notifications.
#
# 2. Security advice:
#    Restrict access to the script and scheduler tasks by properly setting policies
#    and user permissions to prevent unauthorized changes or misuse.
#
# 3. Integration tips:
#    You can integrate the email notifications into your existing monitoring or alerting system
#    by using dedicated mailbox filters or forwarding.

# Logging the start of the script execution
:log info "Script NotifyUserLoginAttempts - Started.";

# Get device details and current date/time
# Get the device name (from /system identity)
:local DeviceName [/system identity get name];
# Get the current time
:local Time [/system clock get time];
# Get the current date
:local Date [/system clock get date];
# Initialize variable for email message text
:local EmailMessageText "";

# Global variable to keep track of the last processed log entry
# This variable stores the index (ID) of the last processed login-related log record
:global ParseLogAccountEndArrayID;

# Retrieve log entries related to "account"
# This gets all log entries where the topic contains the word "account" (typically login events)
:local IDsEventsAccount [/log find where topics ~ "account"];

# Get the total number of log entries and determine the bounds for processing
# Get the total number of log entries
:local LenArrayIDs [:len $IDsEventsAccount];
# Index of the last processed entry (based on previously saved global variable)
# Finds where the last processed ID is located in the current log entries
:local StartArrayID [:find $IDsEventsAccount $ParseLogAccountEndArrayID];
# Index of the last entry in the array (most recent log)
:local EndArrayID ($IDsEventsAccount -> ($LenArrayIDs-1));

# Check if there are new events to process
# Proceed only if the log has changed since the last run
:if ($EndArrayID != $ParseLogAccountEndArrayID and [:tobool $ParseLogAccountEndArrayID]) do={

	# Logging that new events were found
	:log info "Script NotifyUserLoginAttempts - New events found.";

	# Iterate through each new event and build the email message
	# Loop through new events (from the last known up to the most recent)
	:for KeyArray from=($StartArrayID+1) to=($LenArrayIDs-1) do={
		:local IDMessage ($IDsEventsAccount -> $KeyArray);
		# Confirm the log entry still exists (for safety)
		:if ([:len [/log find where .id=$IDMessage]] > 0) do={
			# Extract the time and message from the log
			:local time [/log get $IDMessage time];
			:local message [/log get $IDMessage message];
			# Append log entry to the message text
			:set EmailMessageText ($EmailMessageText . "\n\r   $time - $message;");
		}
	}

	# Logging that events have been processed and notifications are being sent
	:log info "Script NotifyUserLoginAttempts - Events processed. Sending notifications.";

	# Send email notification
	# Recipient email address
	:local SendTo "YOUR_NAME@DOMAIN.com";
	# Email subject
	:local Subject "AUTH: $DeviceName [$Date $Time]";
	# Email message text
	# Multiline message including all new login attempts
	:local MessageText "User Login Attempt Notification
$EmailMessageText
	
This is an automated message.";
	# File name (empty as no file is attached)
	:local FileName "";
	# Get the function for sending email
	# Looks for another script named "SendEmailFunction" that actually performs email sending
	:local SendEmail [:parse [/system script get SendEmailFunction source]];
	# Send the email
	$SendEmail SendTo=$SendTo TextMail=$MessageText Subject=$Subject FileName=$FileName;
}

# Update global variable with the ID of the last processed log entry
# Save the current position to avoid reprocessing same logs next time
:set ParseLogAccountEndArrayID $EndArrayID;

# Logging the successful completion of the script
:log info "Script NotifyUserLoginAttempts - Completed.";
