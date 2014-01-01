#!/bin/bash

adb shell mkdir "/sdcard/Music/$1"
adb push "$1" "/sdcard/Music/$1"
