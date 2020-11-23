#!/bin/bash

TMPDIR='/tmp/vimtmp'
mkdir -p ${TMPDIR}

TIMESTAMP="$(date +'%j%b%d_%H-%M-%S')"
if [ "$1" == "last" ] && [ "$(ls -A $TMPDIR)" != "" ]; then
    echo hi
    FILE="${TMPDIR}/$(ls -t /tmp/vimtmp | head -n 1)"
else
    FILE="${TMPDIR}/${TIMESTAMP}.txt"
fi

st -n "_scratchpad" -e nvim "${FILE}" -c "cd $TMPDIR"

if [ -e "${FILE}" ]; then
    NUMLINES=$(wc -l "${FILE}" | cut -d ' ' -f 1)
    NUMCHARS=$(wc -m "${FILE}" | cut -d ' ' -f 1)
    if [ "${NUMLINES}" -ne "1" ]; then
        PLURAL='s'
    fi
    xclip -selection clipboard "${FILE}"
    notify-send "Copied ${NUMLINES} line${PLURAL} and ${NUMCHARS} chars from ${FILE} into clipboard"
fi
