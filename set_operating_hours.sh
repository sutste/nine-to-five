#!/bin/bash

# Check if two arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <wakeup_time> <halt_time>"
    exit 1
fi

wakeup_time=$1  # e.g., "06:00"
halt_time=$2    # e.g., "23:00"
wakeup_time_epoch_seconds=$(date '+%s' -d $wakeup_time)
halt_time_epoch_seconds=$(date '+%s' -d $halt_time)
now_epoch_seconds=$(date '+%s')

echo "*** Script run time: $(date)"
# echo "wakeup_time:          $wakeup_time ->  $wakeup_time_epoch_seconds"
# echo "halt_time:            $halt_time   ->  $halt_time_epoch_seconds"
# echo "now_epoch_seconds:    $now_epoch_seconds"

# Check if today halt_time is passed -> use tomorrow halt_time
if (( now_epoch_seconds > halt_time_epoch_seconds )); then
    # Set tomorrow halt_time
    halt_time_epoch_seconds=$(date '+%s' -d "tomorrow $halt_time")
    echo "Next halt time: $(date -d "tomorrow $halt_time")";
else
    echo "Next halt time: $(date -d $halt_time)";
fi;

# Calculate halt time in minutes from now
halt_time_in_minutes=$(( ($halt_time_epoch_seconds-$now_epoch_seconds+60)/60 ))
# Schedule shutdown to halt in halt_time_in_minutes. Ensure no smaller than one minute delay
/sbin/shutdown -h +$(( $halt_time_in_minutes > 1 ? $halt_time_in_minutes : 1 ))

# Next wakeup_time has to be after halt_time
if (( wakeup_time_epoch_seconds > halt_time_epoch_seconds )); then
    echo "Next wakeup time: $(date -d $wakeup_time)";
else
    # Otherwise set tomorrow wakeup_time
    wakeup_time_epoch_seconds=$(date '+%s' -d "tomorrow $wakeup_time")
    echo "Next wakeup time: $(date -d "tomorrow $wakeup_time")";
fi;

# Directly set the next wake time
/sbin/hwclock --hctosys
echo 0 | sudo tee /sys/class/rtc/rtc0/wakealarm >/dev/null
echo $wakeup_time_epoch_seconds | sudo tee /sys/class/rtc/rtc0/wakealarm >/dev/null
