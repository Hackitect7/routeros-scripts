# The script is intended for RouterOS.
# Script name: "CPUOverloadCheck"
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
# This script monitors the device's CPU usage over a number of samples
# and sends an email notification if the average CPU load exceeds a defined threshold.
#
# The script collects several CPU load values at intervals, calculates the average,
# and if the average is too high, triggers an alert with details.
#
# Example of the email message text sent:
#
# Subject: Mikrotik CPU Average Overload: Router01 - 83% [01/07/2025 14:35:22]
#
# CPU ARM utilization exceeded 70% threshold. Result of 5 CPU load measurements:
# 88% 85% 82% 77% 83%
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
#        name=CPUOverloadCheck \
#        interval=5m \
#        comment="CPU Overload Check with concurrent run protection" \
#        on-event="\
#            :local ScriptName \"CPUOverloadCheck\"; \
#            :local ScriptRunning [system script job find where script=\$ScriptName]; \
#            :if (\$ScriptRunning) do={ \
#                :log info \"The script \$ScriptName cannot be run, it is already running (consider increasing delay or reducing NumberOfMeasurements)\"; \
#            } else={ \
#                /system script run \$ScriptName; \
#            }" \
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

# Log the start of the script
:log info "Script CPUOverloadCheck - Started.";

# Define the average load threshold and number of measurements
# Threshold (in percent)
:local DeviceAverageLoadThreshold 70;
# Number of CPU load readings
:local NumberOfMeasurements 5;

# Retrieve device details
:local DeviceName [/system identity get name];
:local Time [/system clock get time];
:local Date [/system clock get date];
:local CPUModel [/system resource get cpu];

# Initialize variables
:local Load 0;
:local Message "";

# Collect CPU load measurements
:for Measurement from=1 to=$NumberOfMeasurements do={
    :local CPULoad [/system resource get cpu-load];
    :set Load ($Load + $CPULoad);
    :set Message ($Message . [:tostr $CPULoad] . "% ");
    # Wait 5 seconds between readings
    :delay 5s;
}

# Calculate average CPU load
:local AverageCPULoad ($Load / $NumberOfMeasurements);
:log info "Average CPU load = $AverageCPULoad%";

# Check if average exceeds threshold
if ($AverageCPULoad > $DeviceAverageLoadThreshold) do={

    # Prepare message
    :set Message "CPU $CPUModel utilization exceeded $DeviceAverageLoadThreshold% threshold. Result of $NumberOfMeasurements CPU load measurements: $Message";

    # Send Email
    # Set your real email address
    :local SendTo "YOUR_NAME@DOMAIN.com";
    :local Subject "Mikrotik CPU Average Overload: $DeviceName - $AverageCPULoad% [$Date $Time]";
    :local MessageText "$Message";
    :local FileName "";

    # Call the email sending function
    :local SendEmail [:parse [/system script get SendEmailFunction source]];
    $SendEmail SendTo=$SendTo TextMail=$MessageText Subject=$Subject FileName=$FileName;
}

# Log the completion of the script
:log info "Script CPUOverloadCheck - Completed.";
