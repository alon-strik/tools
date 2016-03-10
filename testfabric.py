from fabric.api import run
from fabric.api import env

env.user = "vyatta"
env.password = "vyatta"
env.host = "192.168.122.23"

def deploy():

   resp = run('ip a')
   print resp

if __name__ == '__main__':
   deploy()
