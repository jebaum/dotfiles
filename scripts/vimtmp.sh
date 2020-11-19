#!/bin/bash

TMPDIR='/tmp/vimtmp'
mkdir -p ${TMPDIR}

if [ "$1" == "last" ]; then
    FILE="${TMPDIR}/$(ls -t /tmp/vimtmp | head -n 1)"
else
    TIMESTAMP="$(date +'%j_%H:%M:%S')"
    FILE="${TMPDIR}/${TIMESTAMP}.txt"
fi

st -n "_scratchpad" -e nvim "${FILE}"

if [ -e "${FILE}" ]; then
    NUMLINES=$(wc -l "${FILE}" | cut -d ' ' -f 1)
    NUMCHARS=$(wc -m "${FILE}" | cut -d ' ' -f 1)
    if [ "${NUMLINES}" -ne "1" ]; then
        PLURAL='s'
    fi
    xclip "${FILE}"
    notify-send "Copied ${NUMLINES} line${PLURAL} and ${NUMCHARS} chars from ${FILE} into clipboard"
fi
