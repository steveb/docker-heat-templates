#!/bin/sh

set -e
yum -y install \
    python-devel \
    python-pip \
    git \
    gcc \
    sqlite \
    crudini \
    libffi-devel \
    libxml2-devel \
    libxslt-devel \
    libyaml-devel \
    openssl-devel \
    yum-plugin-remove-with-leaves \
    mariadb \
    MySQL-python

ls -la /opt/heat
cd /opt/heat

# workaround setuptools which doesn't work with pbr
pip install -U "setuptools<8.0"

pip install -r requirements.txt
pip install ./

mkdir -p /etc/heat
touch /etc/heat/heat.conf
cp etc/heat/api-paste.ini /etc/heat/
cp etc/heat/policy.json /etc/heat/

# remove packages to minimise image size
yum -y remove '*-devel'
yum -y remove --remove-leaves gcc
yum -y remove --remove-leaves git
yum -y clean all