#!/usr/bin/env python3

import psutil
import sys

probes = ["k10temp", "coretemp", "zenpower"]

def getcputemp(zone):
    cpu = psutil.sensors_temperatures()
    try:
        temp = int(cpu[zone][0].current)
    except KeyError as ex:
        return None
    return temp

def main():

    for zone in probes:
        temp = getcputemp(zone)
        if temp:
            print(str(temp) + "°C")
            return(0)
    return(1)

if __name__ == '__main__':
    sys.exit(main())
