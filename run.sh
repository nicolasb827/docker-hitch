#!/bin/sh
set -e

exec hitch --pidfile=/run/hitch.pid --user ${HITCH_USER} --group ${HITCH_GROUP} --workers=${HITCH_WORKERS} --config ${HITCH_CONFIG} --backend=[${HITCH_BACKEND}]:${HITCH_BACKEND_PORT} ${HITCH_PARAMS}
