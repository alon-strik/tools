cfy blueprints delete -b nodecellar; cfy blueprints upload -b nodecellar -p openstack-haproxy-blueprint.yaml; cfy deployments create -b nodecellar -d nodecellar -i inputs/openstack-haproxy.yaml.template; cfy executions start -w install -d nodecellar
cfy deployments  outputs -d nodecellar

#cfy executions  start   -w uninstall -d nodecellar
#cfy deployments delete  -d nodecellar



cfy blueprints delete -b fw; cfy blueprints upload -b fw -p fw.yaml; cfy deployments create -b fw -d fw; cfy executions start -w install -d fw

cfy blueprints upload-b cp  -p checkpoint.yaml;cfy deployments  create  -b cp -d cp;cfy executions   start   -w install    -d cp



cfy executions   start   -w uninstall    -d cp;cfy deployments  delete  -d cp ;cfy blueprints   delete  -b cp 


cfy events list --include-logs --execution-id ca56a84e-14dd-4395-8dcd-5750725bbc1d
