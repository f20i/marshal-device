#!/bin/bash

rm -rf /tmp/.X9999-lock

# Reset
adb \
  -H ${ADB_SERVER_HOST} \
  -P ${ADB_SERVER_PORT} \
  -s $DEVICE_SERIAL \
  shell am start -a android.intent.action.MAIN -c android.intent.category.HOME

# Streaming
nice -n -20 \
  adb \
  -H ${ADB_SERVER_HOST} \
  -P ${ADB_SERVER_PORT} \
  -s $DEVICE_SERIAL \
  exec-out \
  screenrecord \
  --output-format=h264 \
  --bit-rate 4M \
  - | \
  ffmpeg \
  -loglevel warning \
  -f h264 \
  -i - \
  -f flv \
  $RTMP_URL/${DEVICE_SERIAL} &

# VNC
Xvfb :9999 -screen 0 ${RESOLUTION}x16 -ac &

sleep 2s

x11vnc -ncache 10 -display :9999 -nopw -noshm -geometry ${RESOLUTION} -forever &

websockify --web /usr/share/novnc/ 0.0.0.0:6080 localhost:5900 &

uv run poe start &

DISPLAY=:9999 scrcpy --tunnel-host=$ADB_SERVER_HOST --serial=$DEVICE_SERIAL --no-audio