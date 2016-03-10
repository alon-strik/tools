import shlex
import subprocess
import sys
from cloudify_rest_client import CloudifyClient
import urllib2

import json
from os import utime
from os import getpid
from os import path


def getTargetProps(client, depl_id,target_id):

    instance = client.node_instances.get(target_id)

    print '--->   ',
    print instance.runtime_properties.get('external_name'), instance.runtime_properties.get('fixed_ip_address'),
    print '\n'


def check_replationship(deployment):

    client = CloudifyClient('185.98.149.80')

    depl_id = client.deployments.get(deployment).id
    print ('<<< Deployment : ' + depl_id + ' >>>\n')

    deployment_nodes = client.nodes.list(deployment_id=depl_id)

    for node in deployment_nodes:
            print('## node : ' + node.id + ' ##')

#        if 'FortinetFireWall' in node.id:
            instances = client.node_instances.list(deployment_id=depl_id, node_name=node.id)
            for instance in instances:
                print('<< instance id : ' + instance.id + ' >>')

                for relationship in instance.relationships:
#                   if 'connected_to_port' in relationship.get('type'):
                        print 'Node relationship --> ',
                        print relationship.get('target_name'), relationship.get('target_id'), '\n'

                        getTargetProps(client, depl_id, relationship.get('target_id'))

def main():

    check_replationship('test2')

if __name__ == '__main__':
    main()

#
#
#
#
# host_node = ctx._endpoint.get_node(host_instance.node_id)
#
#
# host_id = get_host_id(ctx)   # the parent of the contained_in node
# host_instance = ctx._endpoint.get_node_instance(host_id)
#
#     for relationship in host_instance.target.relationships:
#
