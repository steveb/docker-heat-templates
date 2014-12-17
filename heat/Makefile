KEYSTONE_HOST=192.168.20.112
REGISTRY=192.168.20.112:5001
STACK_NAME=docker-heat
OS_IMAGE=heat-functional-tests-image

create-docker-heat-standalone:
	heat stack-create -f docker-heat-standalone.yaml \
	   -P insecure_registry=$(REGISTRY) \
	   -P image=$(OS_IMAGE) \
	   -P mariadb_image=$(REGISTRY)/kollaglue/fedora-rdo-mariadb \
	   -P rabbitmq_image=$(REGISTRY)/kollaglue/fedora-rdo-rabbitmq \
	   -P heat_engine_image=$(REGISTRY)/stevebake/heat-engine-standalone \
	   -P heat_api_image=$(REGISTRY)/stevebake/heat-api-standalone \
	   -P keystone_host=$(KEYSTONE_HOST) \
	   docker-heat

create-example-kubelet-apache:
	heat stack-create -f example-kubelet-apache.yaml \
	   -P image=$(OS_IMAGE) \
	   -P apache_image=$(REGISTRY)/fedora/apache \
	   kubelet-apache
