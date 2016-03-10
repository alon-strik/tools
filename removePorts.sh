#!/usr/bin/env bash
for x in \
    `neutron port-list | grep 192.168 | awk '{print $2}'`; do neutron port-update $x --device_owner compute:None ;  neutron port-delete $x;
done

for x in \
    `neutron port-list | grep 10.20   | awk '{print $2}'`; do neutron port-update $x --device_owner compute:None ;  neutron port-delete $x;
done

#neutron port-update $PORT_ID --device_owner compute:None
#neutron port-delete $PORT_ID
