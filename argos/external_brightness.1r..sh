#!/usr/bin/env bash
STEPS="0.1"
MONITORS="DP-1-1 DP-1-2"

echo "|iconName=weather-clear"
echo "---"

for i in $(LC_ALL=C seq 1.0 -${STEPS} ${STEPS})
do
  echo "${i} | bash='for m in ${MONITORS}; do xrandr --output \${m} --brightness ${i}; done' terminal=false"
done
