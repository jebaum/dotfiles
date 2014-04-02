#!/bin/bash

STATUS=$(synclient | grep TouchpadOff | grep -o 1)

if [ "${STATUS}" = "1" ]; then
    synclient TouchpadOff=0
    echo turned touchpad on
else
    synclient TouchpadOff=1
    echo turned touchpad off
fi
