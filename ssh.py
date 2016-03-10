import paramiko
ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect('185.98.149.191',username='admin',password='admin')
stdin, stdout, stderr=ssh.exec_command("execute time")
type(stdin)
stdout.readlines()

