HASS="http://192.168.1.99:8123"
TOKEN="xxx"
PARAMETERS="-s -X GET -H 'Content-Type: application/json'"
CURL="/usr/bin/curl"

${CURL} ${PARAMETERS} -H "Authorization: Bearer ${TOKEN}" --connect-timeout 1 ${HASS}/api/ | grep -q "running"

if [ $? -eq 0 ]
then
  TC=$(${CURL} ${PARAMETERS} -H "Authorization: Bearer ${TOKEN}" ${HASS}/api/states/sensor.temperatura_casa | jq -r '.state')
  TF=$(${CURL} ${PARAMETERS} -H "Authorization: Bearer ${TOKEN}" ${HASS}/api/states/sensor.temperatura_fuera | jq -r '.state')
  HF=$(${CURL} ${PARAMETERS} -H "Authorization: Bearer ${TOKEN}" ${HASS}/api/states/sensor.humedad_fuera | jq -r '.state')
  TABAJO=$(${CURL} ${PARAMETERS} -H "Authorization: Bearer ${TOKEN}" ${HASS}/api/states/sensor.temperatura_abajo | jq -r '.state')
  TARRIBA=$(${CURL} ${PARAMETERS} -H "Authorization: Bearer ${TOKEN}" ${HASS}/api/states/sensor.temperatura_arriba | jq -r '.state')

  echo "${TC}º |"
  echo "---"
  echo "${TF}º fuera"
  echo "${HF}% humedad fuera"
  echo "${TABAJO}º abajo"
  echo "${TARRIBA}º arriba"
else
  echo "X |"
  echo "---"
  echo "Unreachable"
fi
