#!/bin/bash

parallel-moreutils -i -j$(nproc) ffmpeg -i {} -codec:a libmp3lame -qscale:a 0 {}.mp3 -- ./*.mp4
rename .mp4.mp3 .mp3 *.mp4.mp3
