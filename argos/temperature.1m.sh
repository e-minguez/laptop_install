HASS="http://192.168.66.98:8123"
TOKEN="x"
PARAMETERS="-s -X GET"
CURL="/usr/bin/curl"

#CURL="curl -s -X GET -H 'Content-Type: application/json' -H \"Authorization: Bearer ${TOKEN}\" ${HASS}/api/states"

${CURL} ${PARAMETERS} -H "Authorization: Bearer ${TOKEN}" -m 1 ${HASS}/api/ | grep -q "running"

if [ $? -eq 0 ]
then
  TC=$(${CURL} ${PARAMETERS} -H "Authorization: Bearer ${TOKEN}" ${HASS}/api/states/sensor.temperatura_casa | jq -r '.state')
  HC=$(${CURL} ${PARAMETERS} -H "Authorization: Bearer ${TOKEN}" ${HASS}/api/states/sensor.humedad_casa | jq -r '.state')

  echo "${TC}º ${HC}% |"
  echo "---"
  TF=$(${CURL} ${PARAMETERS} -H "Authorization: Bearer ${TOKEN}" ${HASS}/api/states/sensor.temperatura_fuera | jq -r '.state')
  HF=$(${CURL} ${PARAMETERS} -H "Authorization: Bearer ${TOKEN}" ${HASS}/api/states/sensor.humedad_fuera | jq -r '.state')
  TABAJO=$(${CURL} ${PARAMETERS} -H "Authorization: Bearer ${TOKEN}" ${HASS}/api/states/sensor.temperatura_abajo | jq -r '.state')
  TARRIBA=$(${CURL} ${PARAMETERS} -H "Authorization: Bearer ${TOKEN}" ${HASS}/api/states/sensor.temperatura_arriba | jq -r '.state')
  echo "${TF}º fuera"
  echo "${HF}% humedad fuera"
  echo "${TABAJO}º abajo"
  echo "${TARRIBA}º arriba"
else
  echo "X |"
  echo "---"
  echo "Unreachable"
fi
