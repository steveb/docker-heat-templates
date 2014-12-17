#!/bin/sh

set -e

# Iterate over a list of variable names and exit if one is
# undefined.
check_required_vars() {
    for var in $*; do
        if [ -z "${!var}" ]; then
            echo "ERROR: missing $var" >&2
            exit 1
        fi
    done
}

# Dump shell environment to a file
dump_vars() {
    set -o posix
    set > /pid_$$_vars.sh
    set +o posix
}

: ${RABBIT_USER:=guest}
: ${OS_REGION_NAME:=RegionOne}
: ${RABBITMQ_PORT_5672_TCP_ADDR:=127.0.0.1}
: ${MARIADB_PORT_3306_TCP_ADDR:=127.0.0.1}
: ${HEAT_DB_USER:=heat}
: ${HEAT_DB_NAME:=heat}
: ${HEAT_API_SERVICE_PORT:=8004}
: ${HEAT_API_CFN_SERVICE_PORT:=8000}
: ${HEAT_API_PROTOCOL:=http}

check_required_vars \
    HEAT_DB_PASSWORD \
    RABBIT_PASSWORD \
    AUTH_ENCRYPTION_KEY \
    HEAT_API_SERVICE_HOST \
    OS_AUTH_URL

dump_vars

# common
crudini --set /etc/heat/heat.conf DEFAULT log_file ""
crudini --set /etc/heat/heat.conf DEFAULT use_stderr True
crudini --set /etc/heat/heat.conf DEFAULT debug True
crudini --set /etc/heat/heat.conf DEFAULT rpc_backend heat.openstack.common.rpc.impl_kombu
crudini --set /etc/heat/heat.conf DEFAULT region_name_for_services ${OS_REGION_NAME}
crudini --set /etc/heat/heat.conf DEFAULT auth_encryption_key ${AUTH_ENCRYPTION_KEY}

# heat-engine
crudini --set /etc/heat/heat.conf DEFAULT rabbit_host \
    ${RABBITMQ_PORT_5672_TCP_ADDR}
crudini --set /etc/heat/heat.conf DEFAULT rabbit_userid \
    ${RABBIT_USER}
crudini --set /etc/heat/heat.conf DEFAULT rabbit_password \
    ${RABBIT_PASSWORD}

crudini --set /etc/heat/heat.conf DEFAULT heat_metadata_server_url \
    http://${HEAT_API_SERVICE_HOST}:8000
crudini --set /etc/heat/heat.conf DEFAULT heat_waitcondition_server_url \
    http://${HEAT_API_SERVICE_HOST}:8000/v1/waitcondition

crudini --set /etc/heat/heat.conf database connection \
    mysql://${HEAT_DB_USER}:${HEAT_DB_PASSWORD}@${MARIADB_PORT_3306_TCP_ADDR}/${HEAT_DB_NAME}

crudini --set /etc/heat/heat.conf clients_heat url \
    "${HEAT_API_PROTOCOL}://${HEAT_API_SERVICE_HOST}:${HEAT_API_SERVICE_PORT}/v1/%(tenant_id)s"

# heat-api
crudini --set /etc/heat/heat.conf heat_api bind_port ${HEAT_API_SERVICE_PORT}
crudini --set /etc/heat/heat.conf keystone_authtoken auth_uri ${OS_AUTH_URL}
crudini --set /etc/heat/heat.conf paste_deploy flavor standalone

# heat-api-cfn
crudini --set /etc/heat/heat.conf heat_api_cfn bind_port ${HEAT_API_CFN_SERVICE_PORT}
crudini --set /etc/heat/heat.conf ec2authtoken auth_uri ${OS_AUTH_URL}

