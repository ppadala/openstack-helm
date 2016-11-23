.PHONY: $(shell find . -maxdepth 1 -mindepth 1 -type d)

all: openstack europe-example-region

europe-example-region: build-europe-example-region

openstack: barbican cinder designate horizon ironic keystone glance manila memcached neutron nova rabbitmq neutron_vendor
openstack: build-openstack

barbican: utils postgres
barbican: build-barbican

cinder: utils postgres
cinder: build-cinder

designate: utils mariadb
designate: build-designate


glance: utils postgres
glance: build-glance

horizon: utils
horizon: build-horizon

ironic: utils postgres
ironic: build-ironic

keystone: utils postgres
keystone: build-keystone

manila: utils postgres
manila: build-manila

memcached: build-memcached

nova: utils postgres
nova: build-nova

neutron: utils postgres
neutron: build-neutron

neutron_vendor: utils
neutron_vendor: build-neutron_vendor

#dependencies
mariadb: build-mariadb
postgres: build-postgres
rabbitmq: build-rabbitmq
utils: build-utils

build-%:
	if [ -f $*/requirements.yaml ]; then helm dep up $*; fi
	helm package $*

lint: lint-barbican lint-cinder lint-designate lint-europe-example-region
lint: lint-glance lint-horizon lint-ironic lint-keystone lint-mariadb
lint: lint-memcached lint-neutron lint-nova lint-openstack lint-postgres
lint: lint-neutron_vendor lint-rabbitmq lint-utils
lint-%:
	helm lint $*

