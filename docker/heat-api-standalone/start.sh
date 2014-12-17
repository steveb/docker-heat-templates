#!/bin/bash
set -e

. /opt/heat/config-heat.sh

exec /usr/bin/heat-api
