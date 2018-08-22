#!/bin/sh
SLEEPTIME=60
BRIGHTNESS="0.7"
for m in DP-2-1 DP-2-2; do xrandr --output ${m} --brightness ${BRIGHTNESS}; done
killall dropbox
dropbox autostart n
sleep ${SLEEPTIME}
dropbox start &
linphone --iconified --no-video &
#nextcloud &
rm -f /home/edu/.config/autostart/dropbox.desktop
