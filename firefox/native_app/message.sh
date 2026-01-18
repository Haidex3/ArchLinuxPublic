#!/bin/bash

# the message length as 4 hex bytes
printf -v x %08X "${#1}"
# write each of the 4 bytes
printf %b "\x${x:6:2}\x${x:4:2}\x${x:2:2}\x${x:0:2}"
# write the message itself
printf %s "$1"
