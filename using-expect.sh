#!/usr/bin/expect -f
spawn ssh -o stricthostkeychecking=no vyatta@10.30.0.143 
sleep 2
expect "password:"
send -- "cozy@202B\r"
expect "$ "
send -- "configure\r"
expect "# "
send -- "set interfaces ethernet eth3 address 192.168.1.2/30\r"
expect "# "
send -- "set protocols static route 10.1.2.0/24 next-hop 192.168.1.1\r"
expect "# "
send -- "delete interfaces ethernet eth1 address\r"
expect "# "
send -- "commit\r"
expect "# "
send -- "save\r"
expect "# "
send -- "exit\r"
expect "$ "
send -- "exit\r"
#!/usr/bin/expect -f
spawn ssh -o stricthostkeychecking=no admin@10.1.9.81
sleep 2
expect "password: "
send -- "admin\r"
expect "G407-9697: "
send -- "route edit ToSOHO gateway 10.1.2.2\r"
expect "G407-9697: "
send -- "exit\r"

