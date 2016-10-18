#!/bin/bash

# parallel -j 4 'i={}; flac -cd "${i}" | lame -V 0 - "${i/%flac/mp3}"' ::: "$@"

find "${@}" -print0 | xargs -0 -L 1 -P 4 bash -c 'flac -cd "${0}" | lame -V 0 - "${0/%flac/mp3}"'
# -L 1 means take one line of input at a time
# -P 4 means run up to 4 processes at a time
# parallel-moreutils -i -j$(nproc) ffmpeg -i {} -qscale:a 0 {}.mp3 -- ./*.flac
# mkdir flac
# mv *.flac flac/
# rename .flac.mp3 .mp3 *.mp3
