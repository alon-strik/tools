import os
from pyFG import FortiOS
from cloudify.decorators import operation
from cloudify.state import ctx_parameters as inputs

@operation
def portConfig(ctx, **kwargs):

    ctx.logger.info('Start port config task....')

    # forti_host = inputs['fortinet_host']
    # forti_username = inputs['fortinet_user']
    # forti_password = inputs['fortinet_password']
    # lanMode = inputs['fortinet_lan_port_mode']
    # wanMode = inputs['fortinet_wan_port_mode']
    # lanAlias = inputs['fortinet_lan_alias']
    # wanAlias = inputs['fortinet_wan_alias']
    # lanIp = inputs['fortinet_lan_port_ip']
    # wanIp = inputs['fortinet_wan_port_ip']
    # lanMask = inputs['fortinet_lan_port_mask']
    # wanMask = inputs['fortinet_wan_port_mask']

#    CEip = inputs['CE1_host']
#####
    # ctx.logger.info('Param1 {0} '.format(lanMode))
    # ctx.logger.info('Param2 {0} '.format(wanMode))
    # ctx.logger.info('Param3 {0} '.format(lanAlias))
    # ctx.logger.info('Param4 {0} '.format(wanAlias))

    ctx.logger.info('Node.id {0} '.format(ctx.node.id))
    ctx.logger.info('Node.name {0} '.format(ctx.node.name))

    host_id = ctx.get_host_id   # the parent of the contained_in node
    host_instance = ctx._endpoint.get_node_instance(host_id)
#
    for relationship in host_instance.target.relationships:
        ctx.logger.info('relationship {0} '.format(relationship.get('target_name')))

    #ctx.logger.info('node : {0} '.format(node))

    #
    #
    # ctx.node.properties[PROP_HOST_TYPE]

    # for node_instance in node_instances:
    #     if node_instance.node_id in constants.SECURITY_GROUPS:
    #         run_props = node_instance.runtime_properties
    #         resources[node_instance.node_id] = {
    #             'id': run_props[constants.NAME],
    #             constants.TARGET_TAGS: run_props[constants.TARGET_TAGS],
    #             constants.SOURCE_TAGS: run_props[constants.SOURCE_TAGS]
    #         }
    #

#####

#     ctx.logger.info('Open connection to host {0} '.format(forti_host))
#     conn = FortiOS(forti_host, username=forti_username, password=forti_password)
#     conn.open()
#
#     if lanMode == 'dhcp':
#         command = 'config system interface\n  edit port2\n  set mode dhcp\n  set allowaccess ping\n  set alias ' + lanAlias +'\nend'
#
#     if lanMode == 'static':
#         command = 'config system interface\n  edit port2\n  set mode static\n  set allowaccess ping\n  set alias ' \
#                   + lanAlias +'\n' + '  set ip ' + lanIp + ' ' + lanMask + '\nend'
#
#     ctx.logger.info('Execute command: {0}'.format(command))
#     execCmd(conn, command)
#
#     conn = FortiOS(forti_host, username=forti_username, password=forti_password)
#     conn.open()
#
#     if wanMode == 'dhcp':
#         command = 'config system interface\n  edit port3\n  set mode dhcp\n  set alias ' + wanAlias + '\nend'
#
#     if wanMode == 'static':
#         command = 'config system interface\n  edit port3\n  set mode static\n  set allowaccess ping\n  set alias ' \
#                   + wanAlias +'\n' + '  set ip ' + wanIp + ' ' + wanMask + '\nend'
#
#     ctx.logger.info('Execute command: {0}'.format(command))
#     execCmd(conn, command)
#
#
# def execCmd(conn, command):
#
#     conn.execute_command(command)
#     conn.close()
#
#
#
