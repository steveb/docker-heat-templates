#!/bin/bash
set -e

. /opt/heat/config-heat.sh

check_required_vars MARIADB_PORT_3306_TCP_ADDR DB_ROOT_PASSWORD \
                    HEAT_DB_NAME HEAT_DB_USER HEAT_DB_PASSWORD

mysql -h ${MARIADB_PORT_3306_TCP_ADDR} -u root -p${DB_ROOT_PASSWORD} mysql <<EOF
CREATE DATABASE IF NOT EXISTS ${HEAT_DB_NAME} DEFAULT CHARACTER SET utf8;
GRANT ALL PRIVILEGES ON ${HEAT_DB_NAME}.* TO
    '${HEAT_DB_USER}'@'%' IDENTIFIED BY '${HEAT_DB_PASSWORD}'
EOF

/usr/bin/heat-manage db_sync

exec /usr/bin/heat-engine
