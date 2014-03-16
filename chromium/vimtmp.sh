#!/bin/bash

TMPDIR='/tmp/chromevim'
mkdir -p ${TMPDIR}

# FILE="$(mktemp -p '/tmp/chromevim' XXXXXX)"
TIMESTAMP="$(date +'%j_%_H-%M-%S')"
FILE="${TMPDIR}/${TIMESTAMP}.txt"

i3-msg "workspace number 3: vps"
urxvt -name chromevim -e vim "${FILE}"

if [ -e "${FILE}" ]; then
    NUMLINES=$(wc -l "${FILE}" | cut -d ' ' -f 1)
    NUMCHARS=$(wc -m "${FILE}" | cut -d ' ' -f 1)
    if [ "${NUMLINES}" -ne "1" ]; then
        PLURAL='s'
    fi
    xclip "${FILE}"
    notify-send "Copied ${NUMLINES} line${PLURAL} and ${NUMCHARS} chars from ${FILE} into clipboard"
fi
