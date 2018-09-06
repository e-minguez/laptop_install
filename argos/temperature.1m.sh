HASS="http://192.168.1.2:8123"
CURL="curl -s -X GET -H 'Content-Type: application/json' ${HASS}/api/states"

curl --connect-timeout 1 -s http://192.168.1.2:8123/api/ | grep -q "running"

if [ $? -eq 0 ]
then
  TI=$(${CURL}/sensor.temperature | jq -r '.state')
  TO=$(${CURL}/sensor.temperature_outside | jq -r '.state')
  HO=$(${CURL}/sensor.humidity_outside | jq -r '.state')

  echo "${TI}º |"
  echo "---"
  echo "${TO}º outside"
  echo "${HO}% humidity outside"
else
  echo "X |"
  echo "---"
  echo "Unreachable"
fi
