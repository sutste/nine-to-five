# Set Operating Hours of your Debian/Linux Computer
I use this script to set the operating hours of my [Raspberry Pi 5](https://www.raspberrypi.com/products/raspberry-pi-5/). It is automatically started and shutdown at the configured times. The commands used, *shall* be available with Debian/Linux based OS. I run the Raspberry Pi 5 with Raspberry Pi OS.

**Important:** The computer requires a RTC (real-time clock) to keep the date/time accurate during it is switched off. E.g. the Raspberry Pi 5 supports an optional [external battery](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#add-a-backup-battery) to power the RTC. This is highly recommended to make this configuration accurate. Standard PCs usually have an external powered RTC already.

## Script usage
The script takes two arguments, first the wakeup-time and second the halt-time. E.g.
```./set_operating_hours.sh 09:00 17:00```

With this, the computer is shutdown at 5pm and is started at 9am on the next day.

## Crontab configuration
To run the script after each startup, it is configured with crontab.

```
sudo crontab -e
```

```
# m h  dom mon dow   command
@reboot sleep 60; <PATH_TO_SCRIPT>/set_operating_hours.sh 09:00 17:00 >> <LOG_DIRECTORY>/operating_hours.log 2>&1
```

In the above example: 
- The script is started after each reboot (```@reboot```), with a 60 seconds delay (```sleep 60;```)
- The computer shall operate from 9am to 5pm (```<PATH_TO_SCRIPT>/set_operating_hours.sh 09:00 17:00```)
- And the output of the script is written to a logfile (```<LOG_DIRECTORY>/operating_hours.log 2>&1```)
