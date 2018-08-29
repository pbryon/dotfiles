#!/usr/bin/env bash

## Get the touchpad id. The -P means perl regular expressions (for \K)
## the -i makes it case insensitive (better portability)
## and the -o means print only the matched portion.
## The \K discards anything matched before it so this command will print the numeric id only.

touchpad=$(xinput list | grep -iPo 'touchpad.*id=\K\d+')
trackpoint=$(xinput list | grep -iPo 'trackpoint.*id=\K\d+')
mouse="razer"
on="0"
off="1"
## Run every second
while :
do
    ## Disable the touchpad if there is a mouse connected
    ## and enable it if there is none.
    xinput list | grep -iq $mouse &&  xinput set-prop $touchpad "Synaptics Off" $off || xinput set-prop $touchpad "Synaptics Off" $on
    
    ## Always disable trackpoint:
    xinput disable "$trackpoint" 
    ## wait one second to avoind spamming your CPU
    sleep 1
done
