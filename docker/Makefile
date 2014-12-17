# image building parameters
GIT_ORIGIN=/home/steveb/dev/localstack/heat
BRANCH=bug/1402472
TAG=latest

IMAGES=\
    heat-base-standalone \
    heat-api-standalone \
    heat-api-cfn-standalone \
    heat-engine-standalone

# container run parameters
REGISTRY=192.168.20.112:5001

# container environment values
DB_ROOT_PASSWORD=ZDM2YTYzYjI2MDIzNWZkMmFiOTA5MTE3
HEAT_DB_PASSWORD=NDc5NTY0NmZkNDBjNTVmNmUyNDgzODM3
AUTH_ENCRYPTION_KEY=ZmVmYWI4Y2EzYTY2MzU4MGU0MWY2ZjJl
RABBIT_PASSWORD=guest
OS_AUTH_URL=http://10.16.17.66:5000/v2.0
HEAT_API_SERVICE_HOST=$(shell ip route get $$(ip route | awk '$$1 == "default" {print $$3}') | awk '$$4 == "src" {print $$5}')

start:
	docker run --expose 5672 \
	    -d --name heat-standalone-rabbitmq \
	    kollaglue/fedora-rdo-rabbitmq
	docker run --expose 3306 \
	    --env DB_ROOT_PASSWORD=$(DB_ROOT_PASSWORD) \
	    --name heat-standalone-mariadb \
	    -d kollaglue/fedora-rdo-mariadb
	
	docker run \
	    --link heat-standalone-mariadb:mariadb \
	    --link heat-standalone-rabbitmq:rabbitmq \
	    --env DB_ROOT_PASSWORD=$(DB_ROOT_PASSWORD) \
	    --env HEAT_DB_PASSWORD=$(HEAT_DB_PASSWORD) \
	    --env AUTH_ENCRYPTION_KEY=$(AUTH_ENCRYPTION_KEY) \
	    --env HEAT_API_SERVICE_HOST=$(HEAT_API_SERVICE_HOST) \
	    --env RABBIT_PASSWORD=$(RABBIT_PASSWORD) \
	    --env HEAT_API_SERVICE_HOST=$(HEAT_API_SERVICE_HOST) \
	    --env OS_AUTH_URL=$(OS_AUTH_URL) \
	    --name heat-engine-standalone \
	    -d stevebake/heat-engine-standalone

stop:
	docker rm -f heat-engine-standalone || true
	docker rm -f heat-standalone-rabbitmq || true
	docker rm -f heat-standalone-mariadb || true

bounce: stop start

.PHONY: images $(IMAGES)

images: $(IMAGES)

$(IMAGES):
	GIT_ORIGIN=$(GIT_ORIGIN) BRANCH=$(BRANCH) TAG=$(TAG) $(MAKE) -C $@