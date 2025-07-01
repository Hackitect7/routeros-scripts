# The script is intended for RouterOS.
# Script name: "SendEmailFunction"
# Author: Hackitect7
# Year: 2025
# GitHub: https://github.com/Hackitect7/routeros-scripts
# License: MIT
#
# Description:
# This function script is designed to send emails using SMTP.
# It is intended to be called from other scripts to handle email notifications
# (e.g., NotifyUserLoginAttempts or similar monitoring/alerting scripts).
#
# Usage:
# This script should NOT be executed directly. It must be called from other scripts
# using [:parse [/system script get SendEmailFunction source]].
#
# Requirements:
# - You must configure the sender’s email, password, SMTP server and port.
# - The SMTP account must allow access from MikroTik (e.g., App Passwords for Gmail).
# - "Don't Require Permissions" checkbox MUST be checked to allow it to be run by other scripts.
#
# Configuration:
# - SENDER_NAME@DOMAIN.com: Replace with the real sender email address that will appear as the "From" address.
# - SENDER_PASSWORD: The password (or app password) for the sender email account.
# - SENDER_SMTP_SERVER: The domain name or IP address of the SMTP server used for sending emails.
# - SENDER_NAME@DOMAIN.com (again): Also used as the SMTP username for authentication.
# NOTE:
# - Some mail providers (like Gmail, Outlook) require enabling "App Passwords" or "Less secure apps" access for SMTP to work.
# - Make sure your firewall allows outbound traffic to port 465 or your selected SMTP port.
#
# Policies:
# - Leave all policy checkboxes UNCHECKED (permissions are delegated by the caller).
#
# Variables expected to be passed in the caller script:
# - $SendTo       — Recipient's email address
# - $Subject      — Email subject line
# - $TextMail     — Email body text
# - $FileName     — Optional file to attach (leave blank if unused)
#
# Example usage from another script:
#     :local SendEmail [:parse [/system script get SendEmailFunction source]];
#     $SendEmail SendTo="user@example.com" TextMail="Hello" Subject="Test" FileName=""

# Log the start of the script execution
:log info "Script SendEmailFunction - Started.";

# Variables for configuration
# Sender email address
:local SendFrom "SENDER_NAME@DOMAIN.com";
# Password for the sender's email account
:local PasswordMail "SENDER_PASSWORD";
# SMTP server for sending email
:local SmtpServer [:resolve "SENDER_SMTP_SERVER"];
# Username for SMTP authentication
:local UserName "SENDER_NAME@DOMAIN.com";
# Port for SMTP connection (typically 465 for TLS)
:local SmtpPort 465;
# Use TLS (encryption)
:local UseTLS "yes";

# Main email sending script
:if ([:len $PasswordMail] = 0) do={ 
	:log error "No password provided for email sending. Process aborted.";
} else={
	/tool e-mail send to=$SendTo \
		server=$SmtpServer \
		port=$SmtpPort \
		tls=$UseTLS \
		user=$UserName \
		password=$PasswordMail \
		from=$SendFrom \
		subject=$Subject \
		body=$TextMail \
		file=$FileName;
	:log info "Script SendEmailFunction - Email sent to $SendTo";
}

# Log completion of the process
:log info "Script SendEmailFunction - Completed.";
