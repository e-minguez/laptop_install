#!/bin/bash
AP=$1
PASSWORD=$2

CONNAME="${AP}"
CIPHER="wpa-psk"
DEVICE=$(nmcli -f DEVICE,TYPE device | awk '/wifi/ { print $1 }')

# https://docs.fedoraproject.org/en-US/Fedora/25/html-single/Networking_Guide/index.html#sec-Using_the_NetworkManager_Command_Line_Tool_nmcli
nmcli connection add con-name ${CONNAME} \
  ifname ${DEVICE} type wifi ssid ${AP}
nmcli con modify ${CONNAME} wifi-sec.key-mgmt ${CIPHER}
nmcli con modify ${CONNAME} wifi-sec.psk ${PASSWORD}
nmcli radio wifi on
nmcli con down ${CONNAME}
nmcli con up ${CONNAME}
