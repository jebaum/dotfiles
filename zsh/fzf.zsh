# Key bindings
# ------------
export FZF_DEFAULT_OPTS="-x" # -x is a superset of the other modes
                             # prepend string with single quote for exact match
# CTRL-T - Paste the selected file path(s) into the command line
__fsel() {
  set -o nonomatch
  command find * -path '*/\.*' -prune \
    -o -type f -print \
    -o -type d -print \
    -o -type l -print 2> /dev/null | fzf -m | while read item; do
    printf '%q ' "$item"
  done
  echo
}

if [[ $- =~ i ]]; then

if [ -n "$TMUX_PANE" -a ${FZF_TMUX:-1} -ne 0 -a ${LINES:-40} -gt 15 ]; then
  fzf-file-widget() {
    local height
    height=${FZF_TMUX_HEIGHT:-40%}
    if [[ $height =~ %$ ]]; then
      height="-p ${height%\%}"
    else
      height="-l $height"
    fi
    tmux split-window $height "zsh -c 'source ~/.fzf.zsh; tmux send-keys -t $TMUX_PANE \"\$(__fsel)\"'"
  }
else
  fzf-file-widget() {
    LBUFFER="${LBUFFER}$(__fsel)"
    zle redisplay
  }
fi
zle     -N   fzf-file-widget
bindkey '^T' fzf-file-widget

# ALT-D - cd into the selected directory
fzf-cd-widget() {

   # TODO when this gets ironed out, update the command in .config/ranger/commands.py too
   # maybe use an environment variable to keep them in sync?
   # TODO maintain a cache for this? it's slow from ~
   # different things for d and D?
   # also make similar updates to the C-t thing, but ^t isn't a thing
   # would also want a cache for ^T
   # alternatively, could do something like this:
   #    strings /var/lib/mlocate/mlocate.db | grep -E '^/' | fzf
   # read everything from the database, all directories will start with the '/' character
   DIR="${$(find -L \( -path '*.wine-pipelight' -o -path '*.ivy2*' -o -path '*.texlive*' \
     -o -path '*.git' -o -path '*.metadata' -o -path '*_notes' \) \
     -prune -o -type d -print 2>/dev/null | fzf):-.}"
   cd $DIR
   zle reset-prompt
}
zle     -N    fzf-cd-widget
bindkey '^[d' fzf-cd-widget

# CTRL-R - Paste the selected command from history into the command line
fzf-history-widget() {
  LBUFFER=$(fc -l 1 | fzf +s +m -n2..,.. | sed "s/ *[0-9*]* *//")
  zle redisplay
}
zle     -N   fzf-history-widget
bindkey '^R' fzf-history-widget

fi
