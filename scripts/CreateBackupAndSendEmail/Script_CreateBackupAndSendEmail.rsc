# The script is intended for RouterOS.
# Script name: "CreateBackupAndSendEmail"
# Author: Hackitect7
# Year: 2025
# GitHub: https://github.com/Hackitect7/routeros-scripts
# License: MIT
#
# For this script, you need to set the following policies: read, write, policy, test, sensitive
#
# IMPORTANT:
# In the script, locate the lines with the following placeholders and replace them with your actual values:
#     :local SendTo "YOUR_NAME@DOMAIN.com";
#     :local Password "YOUR_BACKUP_ARCHIVE_PASSWORD";
#
# Without proper email and backup password settings, the script will not function correctly.
#
# Description:
# This script creates a secure backup of the RouterOS configuration with a password,
# exports the configuration to an .rsc file,
# and sends the backup file as an email attachment to the specified recipient.
#
# The email contains details about the device, backup filename, and timestamp.
#
# Example of the email message text sent:
#
# Device Backup Notification
#
# Device Name: Router01
# Date: 01/07/2025
# Time: 14:35:22
# Backup File: Router01.backup
# Configuration File (.rsc) also created on the device: Router01.rsc
#
# This is an automated message.
#
# How to apply:
# 1. Open the MikroTik terminal (Winbox -> New Terminal, or SSH/WebFig terminal).
# 2. Create a new script and paste the entire contents of this file:
#
#    /system script add name=CreateBackupAndSendEmail policy=read,write,policy,test,sensitive source=...
#
# 3. Replace the placeholder email address and backup password with your real values.
#
# 4. Ensure that another script named "SendEmailFunction" exists — this script depends on it
#    to send emails with attachments.
#
# 5. Set up a scheduler to run this script at your preferred interval (e.g., daily):
#
#    /system scheduler add \
#        name=CreateBackupAndSendEmail \
#        interval=1d \
#        comment="Daily backup creation and email with attachment" \
#        on-event="/system script run CreateBackupAndSendEmail" \
#        policy=read,write,policy,test,sensitive \
#        start-time=03:00:00
#
# Additional requirements and tips:
#
# 1. SMTP Configuration:
#    Configure SMTP settings correctly under `/tool e-mail`.
#
# 2. Backup password:
#    Use a strong password to encrypt your backup file for security.
#
# 3. Security:
#    Set user permissions and policies cautiously to protect script and backup files.
#
# 4. Disk space:
#    Monitor device storage to avoid backup failures.
#

# Log the start of the script
:log info "Script CreateBackupAndSendEmail - Started.";

# Get device name, current time and date
:local DeviceName [/system identity get name];
:local Date [/system clock get date];
:local Time [/system clock get time];

# Email settings
# Recipient email address
:local SendTo "YOUR_NAME@DOMAIN.com";
# Email subject
:local Subject "Mikrotik BACKUP: $DeviceName [$Date $Time]";

# Backup file settings
# Name of the backup file
:local FileNameBACKUP "$DeviceName.backup";
# Name of the RSC file (exported configuration)
:local FileNameRSC "$DeviceName.rsc";
# Password for the backup file
:local Password "YOUR_BACKUP_ARCHIVE_PASSWORD";

# Create a backup configuration file with encryption
/system backup save name=$FileNameBACKUP password=$Password;

# Export configuration to RSC file
/export file=$FileNameRSC;

# Define email body text with detailed information
:local MessageText "Device Backup Notification

Device Name: $DeviceName
Date: $Date
Time: $Time
Backup File: $FileNameBACKUP
Configuration File (.rsc) also created on the device: $FileNameRSC

This is an automated message.";

# Retrieve the email sending function from a separate script
:local SendEmail [:parse [/system script get SendEmailFunction source]];

# Send the email with the backup file attached
$SendEmail SendTo=$SendTo TextMail=$MessageText Subject=$Subject FileName=$FileNameBACKUP;

# Log the completion of the script
:log info "Script CreateBackupAndSendEmail - Completed.";
