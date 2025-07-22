# The script is intended for RouterOS.
# Script name: "DeviceOverheatingNotification"
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
# where you want to receive critical overheating notifications from RouterOS.
#
# Without this, the script will not be able to send email notifications properly.
#
# Description:
# This script monitors the device's CPU temperature and sends an email notification
# if the temperature exceeds a predefined critical threshold (default 70 °C).
#
# It retrieves the temperature value from /system health, strips any non-numeric characters,
# compares it against the maximum allowed temperature,
# and sends a detailed alert email if the limit is exceeded.
#
# The email includes device name, current temperature, CPU load, date, and time.
#
# Example of the email message text sent:
#
# Subject: Mikrotik CRITICAL: Router01 [01/07/2025 14:35:22]
#
# Critical Alert!
#
# Device: Router01
# Temperature: 72 °C
# CPU Load: 85 %
#
# This is an automated message.
#
# How to apply:
# 1. Open the MikroTik terminal (Winbox -> New Terminal, or SSH/WebFig terminal).
# 2. Create a new script and paste the entire contents of this file:
#
#    /system script add name=DeviceOverheatingNotification policy=read,write,policy,test source=...
#
# 3. Replace the placeholder email address with your real value.
#
# 4. Ensure that another script named "SendEmailFunction" exists — this script depends on it
#    to send alert emails.
#
# 5. Set up a scheduler to run this script periodically (e.g., every 5 minutes):
#
#    /system scheduler add \
#        name=DeviceOverheatingNotification \
#        interval=5m \
#        comment="Device overheating notification" \
#        on-event="/system script run DeviceOverheatingNotification" \
#        policy=read,write,policy,test \
#        start-time=startup
#
# Additional requirements and tips:
#
# 1. SMTP Configuration:
#    Configure SMTP settings correctly under `/tool e-mail`.
#
# 2. Customization:
#    - You can adjust the maximum allowable CPU temperature ($MaxCPUTemp) in the script.
#
# 3. Security:
#    Set user permissions and policies cautiously to protect the script from modification.
#

# Log the start of the script
:log info "Script DeviceOverheatingNotification - Started.";

# Define the maximum allowable CPU temperature in Celsius
:local MaxCPUTemp 70;

# Find the index of the temperature entry in /system health by name "temperature"
:local tempIndex [/system/health find where name="temperature"];

# Retrieve the raw temperature value using the found index
:local tempRaw [/system/health get $tempIndex value];

# If the temperature value is a string (e.g., "38C"), remove the last character (the "C")
:if ([:typeof $tempRaw] = "string") do={
    :set tempRaw [:pick $tempRaw 0 ([:len $tempRaw] - 1)];
}

# Convert the temperature value from string to number for numeric comparison
:local CurrentTemp [:tonum $tempRaw];

# Retrieve current CPU load percentage
:local CurrentCPULoad [/system resource get cpu-load];

# Retrieve the device identity name
:local DeviceName [/system identity get name];

# Retrieve the current time from the system clock
:local Time [/system clock get time];

# Retrieve the current date from the system clock
:local Date [/system clock get date];

# Check if the current temperature exceeds the defined maximum temperature threshold
:if ($CurrentTemp > $MaxCPUTemp) do={

    # Log that the temperature threshold was exceeded and an email will be sent
    :log info "Script DeviceOverheatingNotification - Temperature threshold exceeded! Sending email.";

    # --- BEGIN email notification ---

    # Define the recipient email address
    :local SendTo "YOUR_NAME@DOMAIN.com";

    # Define the email subject including device name, date, and time
    :local Subject "Mikrotik CRITICAL: $DeviceName [$Date $Time]";

    # Define the body text of the email with details about device, temperature, and CPU load
    :local MessageText "Critical Alert!

Device: $DeviceName
Temperature: $CurrentTemp °C
CPU Load: $CurrentCPULoad %

This is an automated message.";

    # Define filename for attachment, empty if no attachment
    :local FileName "";

    # Retrieve the external email sending function source code
    :local SendEmail [:parse [/system script get SendEmailFunction source]];

    # Call the email sending function with the defined parameters
    $SendEmail SendTo=$SendTo TextMail=$MessageText Subject=$Subject FileName=$FileName;

    # --- END email notification ---
}

# Log the completion of the script execution
:log info "Script DeviceOverheatingNotification - Completed.";
