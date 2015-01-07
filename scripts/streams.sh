#!/bin/bash

# based off https://omgren.com/blog/2013/05/05/iptables-rtmpsuck-rtmpdump-mplayer.html

if [ "$1" == "prepare" ]; then
    sudo iptables -t nat -A OUTPUT -p tcp --dport 1935 -m owner \! --uid-owner root -j REDIRECT

    echo "==========================================================================="
    echo "iptables rule set, starting rtmpsuck. refresh the stream to see info dumped"
    echo "==========================================================================="

    sudo rtmpsuck 2>&1 | tee /tmp/streamcrap

    sudo iptables -t nat -D OUTPUT -p tcp --dport 1935 -m owner \! --uid-owner root -j REDIRECT

    echo "====================="
    echo "deleted iptables rule"
    echo "====================="
elif [ "$1" == "run" ]; then

    # XXX sticking this here for now since I kill the script with C-c
    sudo iptables -t nat -D OUTPUT -p tcp --dport 1935 -m owner \! --uid-owner root -j REDIRECT
    OUTPUT=$(cat /tmp/streamcrap)
    tcUrl=$(echo "$OUTPUT" | grep "tcUrl: " | cut -d " " -f 2-)
    app=$(echo "$OUTPUT" | grep "app: " | cut -d " " -f 2-)
    Playpath=$(echo "$OUTPUT" | grep "Playpath: " | cut -d " " -f 2-)
    swfUrl=$(echo "$OUTPUT" | grep "swfUrl: " | cut -d " " -f 2-)
    pageUrl=$(echo "$OUTPUT" | grep "pageUrl: " | cut -d " " -f 2-)
    flashVer=$(echo "$OUTPUT" | grep "flashVer: " | cut -d " " -f 2-)

    echo tcUrl:    $tcUrl
    echo app:      $app
    echo Playpath: $Playpath
    echo swfUrl:   $swfUrl
    echo pageUrl:  $pageUrl
    echo flashVer: $flashVer


    # XXX: for some reason this command doesn't work when run from the script, has to be run right from the shell?
    # sudo rtmpdump -r \"$tcUrl\" -a \"$app\" -y \"$Playpath\" -W \"$swfUrl\" -p \"$pageUrl\" -f \"$flashVer\" -o - | mpv -

    echo "sudo rtmpdump -r \"$tcUrl\" -a \"$app\" -y \"$Playpath\" -W \"$swfUrl\" -p \"$pageUrl\" -f \"$flashVer\" -o - | mpv -" | xclip
    echo "command to run copied to clipboard"
else
    echo 'valid parameters are "prepare" and "run"'
fi
