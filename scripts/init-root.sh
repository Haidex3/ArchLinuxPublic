#!/usr/bin/expect -f
spawn su -c "/home/Haider/scripts/nvidia-fan-curve.sh"
expect "Password:"
send "1112\r"
interact
