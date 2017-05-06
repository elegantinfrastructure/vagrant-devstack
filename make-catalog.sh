#!/bin/sh -ex

SERVICE_HOST=127.0.0.1
PROTOCOL=http

# Execute openstack client and return results in shell variables

osc() {
    eval $(openstack "$@" --prefix osc_ -f shell)
}

#
# Keystone
#

# Create domains, roles, projects and users

openstack role create admin
openstack role create user

openstack project create --domain default admin
openstack project create --domain default service
openstack project create --domain default demo

openstack user create --domain default --password devstack admin
openstack role add --project admin --user admin admin

openstack user create --domain default --password devstack demo
openstack role add --project demo --user demo user

# Create Keystone catalog entries

osc service create --name keystone identity

osc endpoint create \
    --region RegionOne identity public $PROTOCOL://$SERVICE_HOST:5000/identity/v3
osc endpoint create \
    --region RegionOne identity internal $PROTOCOL://$SERVICE_HOST:5000/identity/v3
osc endpoint create \
    --region RegionOne identity admin $PROTOCOL://$SERVICE_HOST:35357/identity/v3
