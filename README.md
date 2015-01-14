Docker images for heat-standalone
=================================

This repository allows you to:

* Build docker container images to allow heat to be run in a stand-alone
  environment
* Launch a stand-alone heat to an OpenStack cloud which itself has a heat
  service

docker
------

This directory contains a Makefile which defines the following targets

* images: builds Docker images for heat-api-standalone,
  heat-api-cfn-standalone and heat-engine-standalone
* heat-standalone-image.tar: Does a docker save of all required images
  (including kollaglue/fedora-rdo-mariadb and kollaglue/fedora-rdo-rabbitmq)
  then creates a single combined tar of all images so that there are no
  duplicate layers
* start, stop: Run a stand-alone heat against a local Docker API
* env: Modify some existing sourced OpenStack credentials to point at the
  stand-alone heat so that it can be used. (Requires $OS_TENANT_ID to be
  defined)

heat
----

docker-heat-standalone.yaml defines a stack which creates a simple
single-node stand-alone heat appliance. It can be created by sourcing some
OpenStack credentials and running:

  make create-docker-heat-standalone

This requires an image built by diskimage-builder which includes the
heat-config-kubelet element found in
https://github.com/openstack/heat-templates/tree/master/hot/software-config