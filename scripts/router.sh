#!/usr/bin/expect -f
spawn telnet 192.168.1.1
expect "Login: "
send "admin\r"
expect "Password: "
send "weroiu\r"
expect " > "
send "reboot\r"
expect eof
