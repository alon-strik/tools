import os
from pyFG import FortiOS
from cloudify.decorators import operation
from cloudify.state import ctx_parameters as inputs

TEMPLATE_CONFIG_FILE = 'portConfig.conf'
CONFIG_FILE = 'portConfig'
FIREWALL_FILE = 'firewall.conf'
TMP_CONFIG_FILE = '/tmp/portConfig'

portIdToSearch = 'portX'
portIpToSearch = 'PORTIP'
portMaskToSearch = 'PORTMASK'
portAliasToSearch = 'ALIASNAME'

@operation
def portConfig(ctx, **kwargs):

    ctx.logger.info('Start port config task....')

    templatePortConfig=ctx.get_resource(TEMPLATE_CONFIG_FILE)
    ctx.download_resource(templatePortConfig, TMP_CONFIG_FILE)

    forti_host = inputs['fortinet_host']
    forti_username = inputs['fortinet_user']
    forti_password = inputs['fortinet_password']

    portnum = inputs['test_port_number']
    portip = inputs['test_ce_port']
    portmask = '255.255.255.0'
    aliasname = 'Internal'

    f  = open(TMP_CONFIG_FILE, 'r+')
    clean  = f.read().replace(portIdToSearch, portnum).replace(portIpToSearch, portip).replace(portMaskToSearch, portmask).replace(portAliasToSearch, aliasname)
    f.write(clean)

    portConf=ctx.get_resource(TMP_CONFIG_FILE)
    ctx.logger.info('New file to execute {0} '.format(portConf))

    ctx.logger.info('Open connection to host {0} '.format(forti_host))
    conn = FortiOS(forti_host, username=forti_username, password=forti_password)
    conn.open()

    execCmd(ctx,conn,portConf)


# @operation
# def configFireWall(ctx, **kwargs):
#
#     ctx.logger.info('Start config firewall task....')
#
#     firewallFile=ctx.get_resource(FIREWALL_FILE)
#
#     forti_host = inputs['fortinet_host']
#     forti_username = inputs['fortinet_user']
#     forti_password = inputs['fortinet_password']
#
#     ctx.logger.info('Open connection to host {0} '.format(forti_host))
#     conn = FortiOS(forti_host, username=forti_username, password=forti_password)
#     conn.open()
#
#     execCmd(ctx,conn,firewallFile)


def execCmd(ctx,conn,configfile):

    ctx.logger.info('Execute command: {0}'.format(configfile))
    conn.execute_command(configfile)
    conn.close()
