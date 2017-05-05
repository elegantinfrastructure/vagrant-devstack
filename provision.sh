#!/bin/bash -xe
#
# Install and provision devstack inside a Vagrant machine
#
# Warming of apt and pip cache idea taken from nand2:
# https://github.com/nand2/vagrant-devstack/blob/master/devstack-bootstrap.sh
#

# Warm up apt and pip cache
sudo rsync -a /vagrant/apt_cache/ /var/cache/apt
sudo mkdir -p /root/.cache
sudo rsync -a /vagrant/pip_cache/ /root/.cache/pip
sudo chown -R root /root/.cache/pip

# Copy back apt and pip cache data on exit
trap cleanup EXIT
function cleanup {
    sudo rsync -a /var/cache/apt/ /vagrant/apt_cache
    sudo rsync -a /root/.cache/pip/ /vagrant/pip_cache
}

# Install misc support programs
sudo apt-get update
sudo apt-get install -y git crudini

# Checkout devstack
[ -d devstack ] || git clone -b stable/ocata git://192.168.1.36/openstack-dev/devstack

# Copy config and run devstack
cp /vagrant/localrc devstack
(cd devstack ; ./stack.sh)

# Clean up all users, endpoints etc
sudo crudini --set /etc/keystone/keystone.conf DEFAULT admin_token devstack
sudo apachectl graceful
export OS_TOKEN=devstack
export OS_URL=http://127.0.0.1:35357/v3
export OS_IDENTITY_API_VERSION=3
OS_ARGS="--os-token $OS_TOKEN --os-url $OS_URL"
for object in project role user service; do
    echo Deleting ${object}s
    for id in `openstack $OS_ARGS $object list -f value | awk '{ print $1 }'`; do
        openstack $OS_ARGS $object delete $id
    done
done
for id in `openstack $OS_ARGS domain list -f value | awk '{ print $1 }'`; do
    [ $id = "default" ] && continue
    openstack $OS_ARGS domain set --disable $id
    openstack $OS_ARGS domain delete $id
done

