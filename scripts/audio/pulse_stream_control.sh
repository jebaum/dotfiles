#!/bin/bash

if [ "$#" != "1" ]; then
    echo requires an argument
    exit
fi

if [ $1 == "xfi" ]; then
    alsa_name="Creative X-Fi"
elif [ $1 == "mobo" ]; then
    alsa_name="HDA Intel PCH"
elif [ $1 == "hdmi" ]; then
    alsa_name="HDA NVidia"
fi

# TODO a single script to change the default sink, lists all options in dmenu? or one keymap per default like before with alsa?
# would use pretty much the same code I've already written here
# then, one keymap per sink in i3 config, to move to a stream to a sink. sink determined by passed in argument in keymap
# or, a single keymap that prompts me with dmenu twice - once to select audio stream, once to select sink to move it to?

# Get information about all currently open audio streams
IFS=$'\n'
stream_id=($(pactl list sink-inputs | grep "Sink Input #" | grep -Eo "[0-9]+"))
stream_application_name=($(pactl list sink-inputs | grep -E "application.name = " | grep -Po  '(?<=\")(.*?)(?=\")'))
stream_application_process=($(pactl list sink-inputs | grep -E "application.process.binary = " | grep -Po  '(?<=\")(.*?)(?=\")'))
stream_sink_id=($(pactl list sink-inputs | grep "Sink: " | grep -Eo "[0-9]+"))
num_streams=${#stream_id[@]}
num_streams=$(($num_streams - 1))

# Get information about currently available sinks
sink_id=($(pactl list sinks | grep "Sink #" | grep -Eo "[0-9]+"))
sink_name=($(pactl list sinks | grep "alsa.card_name = " | grep -Po  '(?<=\")(.*?)(?=\")'))
sink_fullname=($(pactl list sinks | grep "Name: " | awk '{print $2}'))
num_sinks=${#sink_id[@]}
num_sinks=$(($num_sinks - 1))
current_default_sink_index=$(pacmd list-sinks | grep -i '* index:' | awk '{print $3}')

for i in $(seq 0 $num_sinks); do
    sink_id_to_name[$i]=${sink_name[$i]}
done

# TODO hack so that changing the default sink changes where mpv plays - start up mpv with `--mute yes`, then move its stream over, then kill it
# actually, need to play an audio file so that an audio stream gets created. /usr/share/sounds/alsa/Front_Right.wav? --loop=inf
# also, only do this if mpv isn't already running. if an mpv audio stream (or maybe just an mpv provess) is already running, don't move it to the default
# also, either make sure that mpd follows around the default sink or set it up to be its own audio stream. maybe enabling pulse will solve that automatically
# when this is all done, can probably deprecate dotfiles/scripts/audio, or at least most of it

# selected_sink_id=$(for i in $(seq 0 $num_sinks); do
    # echo $i - ${sink_id_to_name[$i]}
# done | dmenu -b -i -nf \#888888 -nb \#1D1F21 -sf \#ffffff -sb \#1D1F21 -fn "-*-terminus-medium-*-*-*-14-*-*-*-*-*-*-*" -l 20 | cut -f 1 -d' ')
# echo $selected_sink_id
# pactl set-default-sink <index or full sink name>


# TODO if there's only one active audio stream, should we skip dmenu?

id=$(for i in $(seq 0 $num_streams); do
    cur_id=${stream_sink_id[$i]}
    echo -e "${stream_id[$i]}  | ${stream_application_name[$i]} - ${stream_application_process[$i]} (currently on ${sink_id_to_name[$cur_id]})"
done | dmenu -b -i -nf \#888888 -nb \#1D1F21 -sf \#ffffff -sb \#1D1F21 -fn "-*-terminus-medium-*-*-*-14-*-*-*-*-*-*-*" -l 20 | cut -f 1 -d' ')


for i in $(seq 0 $num_sinks); do
    current_name=${sink_name[$i]}
    if [ $alsa_name == $current_name ]; then
        pactl move-sink-input $id ${sink_id[$i]}
        break
    fi
done

# load-module module-alsa-source device=hw:0,0
# load-module module-alsa-sink device=hw:2,8
