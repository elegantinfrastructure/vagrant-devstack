#!/bin/sh

for id in `openstack $OS_ARGS domain list -f value | awk '{ print $1 }'`; do
    [ $id = "default" ] && continue
    openstack $OS_ARGS domain set --disable $id
    openstack $OS_ARGS domain delete $id
done

for object in project role user service; do
    echo Deleting ${object}s
    for id in `openstack $OS_ARGS $object list -f value | awk '{ print $1 }'`; do
        openstack $OS_ARGS $object delete $id
    done
done
