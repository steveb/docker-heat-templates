OS_AUTH_URL=http://192.168.20.112:35357/v2.0
STACK_NAME=docker-heat
OS_IMAGE=heat-functional-tests-image

create-docker-heat-standalone:
	heat stack-create -f docker-heat-standalone.yaml \
	   -P image=$(OS_IMAGE) \
	   -P os_auth_url=$(OS_AUTH_URL) \
	   docker-heat

create-example-kubelet-apache:
	heat stack-create -f example-kubelet-apache.yaml \
	   -P image=$(OS_IMAGE) \
	   kubelet-apache
