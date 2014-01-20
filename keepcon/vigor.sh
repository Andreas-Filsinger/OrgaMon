#!/usr/bin/expect


spawn telnet -e x gateway
expect "Account:"
send "admin\r"
expect "Password: "
send "*********\r"
expect "> "
send "show status\r"
expect "> "
send "exit"
exit

