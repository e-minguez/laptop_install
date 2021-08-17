DEVICE="hidpp_battery_0"
ONLINE="/sys/class/power_supply/${DEVICE}/online"
STATUS="/sys/class/power_supply/${DEVICE}/status"
UPOWERDEVICE="mouse_${DEVICE}"

command -v upower &>/dev/null || echo "Missing upower"

if [ $(cat ${ONLINE}) -ne 1 ]; then
  echo "X"
else
  PERC=$(upower -i /org/freedesktop/UPower/devices/${UPOWERDEVICE}| awk '/percentage/ { print $2 }')
  case $(cat ${STATUS}) in
	  "Discharging")

		  echo " ${PERC}"
		  ;;
	  "Charging")
		  echo "  ${PERC}"
		  ;;
  esac
fi
exit 0
