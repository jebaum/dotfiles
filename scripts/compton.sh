#!/bin/bash

### compton
# compton:
# compton --vsync opengl &
# compton with fast fades:
# compton --vsync opengl -r 10 -D 3 -m 0.95 -C -G --dbe --use-ewmh-active-win -f --no-fading-openclose -c &
# compton --vsync opengl -r 10 -D 3 -m 0.95 -C -G --dbe --use-ewmh-active-win -f --no-fading-openclose -c --paint-on-overlay --config $HOME/.compton.conf &
# compton --vsync opengl -r 10 -D 3 -m 0.95 -C -G --dbe --use-ewmh-active-win -f --no-fading-openclose -c --paint-on-overlay --shadow-exclude="name = 'XOSD'" &
### shadow prevention on multihead overlaps, opengl, non-distracting work-mode:

compton_top_offset="-15"
compton_left_offset="-15"
compton_opacity_borders="1.0"
compton_opacity_shadows="0.5"
compton_radius="15"
compton_inactive_dim="0.12"
compton -t "$compton_top_offset" -l "$compton_left_offset" --xinerama-shadow-crop --vsync opengl -e "$compton_opacity_borders" -o "$compton_opacity_shadows" -r "$compton_radius" --inactive-dim=$compton_inactive_dim -D 3 -m 0.95 -C -G --dbe --use-ewmh-active-win -f --no-fading-openclose -c --shadow-exclude="name = 'XOSD'"

