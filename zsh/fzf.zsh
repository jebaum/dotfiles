export FZF_DEFAULT_OPTS="-x --inline-info"
if [[ $- =~ i ]]; then # =~ checks against regex, $- is shell flags, 'i' flag means interactive shell

__fzfcmd() {
  [ ${FZF_TMUX:-1} -eq 1 ] && echo "fzf-tmux -d${FZF_TMUX_HEIGHT:-40%}" || echo "fzf"
}


# CTRL-T - Paste the selected file path(s) into the command line
__fsel() { # fzf-file-widget helper
  command find -L . \( -path '*/\.*' -o -fstype 'dev' -o -fstype 'proc' \) -prune \
    -o -type f -print -o -type d -print -o -type l -print 2> /dev/null | sed 1d |
    cut -b3- | $(__fzfcmd) -m | while read item; do
    printf '%q ' "$item"
  done
  echo
}

fzf-file-widget() {
  LBUFFER="${LBUFFER}$(__fsel)"
  zle redisplay
}
zle     -N   fzf-file-widget
bindkey '^T' fzf-file-widget


# ALT-T - Paste the selected entry from locate output into the command line
fzf-locate-widget() {
  local selected
  if selected=$(locate / | fzf -q "$LBUFFER"); then
    LBUFFER=$selected
  fi
  zle redisplay
}
zle     -N    fzf-locate-widget
bindkey '\et' fzf-locate-widget


# ALT-d and ALT-D - cd into the selected directory using find/locate
fzf-cd-find-widget() {
  cd "${$(find -L . \( -path '*/\.*' -o -fstype 'dev' -o -fstype 'proc' \) -prune \
    -o -type d -print 2> /dev/null | sed 1d | cut -b3- | $(__fzfcmd) +m):-.}"
  zle reset-prompt
}

fzf-cd-locate-widget() {
  # $PWD will be expanded inside sed, so use a nonprinting bullshit character
  # as sed delimiter to make sure the whatever $PWD is doesn't screw up the command
  DIR="${$(strings /var/lib/mlocate/mlocate.db | grep "^${PWD}" 2>/dev/null | sed "s^${PWD}/" | fzf):-.}"
  cd $DIR
  zle reset-prompt
}
zle     -N    fzf-cd-locate-widget
zle     -N    fzf-cd-find-widget
bindkey '^[d' fzf-cd-find-widget
bindkey '^[D' fzf-cd-locate-widget


# CTRL-R - Paste the selected command from history into the command line
fzf-history-widget() {
  local selected restore_no_bang_hist
  if selected=$(fc -l 1 | $(__fzfcmd) +s --tac +m -n2..,.. --tiebreak=index --toggle-sort=ctrl-r -q "$LBUFFER"); then
    num=$(echo "$selected" | head -1 | awk '{print $1}' | sed 's/[^0-9]//g')
    if [ -n "$num" ]; then
      LBUFFER=!$num
      if setopt | grep nobanghist > /dev/null; then
        restore_no_bang_hist=1
        unsetopt no_bang_hist
      fi
      zle expand-history
      [ -n "$restore_no_bang_hist" ] && setopt no_bang_hist
    fi
  fi
  zle redisplay
}
zle     -N   fzf-history-widget
bindkey '^R' fzf-history-widget


# CTRL-O and ALT-O - open file from ag/locate commands
fzf-edit-widget-ag() { fzf-edit-widget ag }
fzf-edit-widget-locate() { fzf-edit-widget locate }

fzf-edit-widget() {
  local oldifs
  oldifs=$IFS
  IFS=$'\n'
  if [ "$1" = "ag" ]; then
    filelist=( $(ag -g '.' 2>/dev/null | fzf -m) )
  elif [ "$1" = "locate" ]; then
    filelist=( $(locate --wholename "$PWD" 2>/dev/null | fzf -m) )
  fi
  if [ -z "$filelist" ]; then
    zle redisplay
  else
    opencmd="${EDITOR} -p "
    opencmd+=$(for item in $filelist; do
      echo -n \"$item\"
      echo -n " "
    done)
    zle kill-whole-line
    zle redisplay
    BUFFER=$opencmd
    zle accept-line
  fi
  IFS=$oldifs
}

zle -N fzf-edit-widget-ag
bindkey '^O'   fzf-edit-widget-ag

zle -N fzf-edit-widget-locate
bindkey '\eo'  fzf-edit-widget-locate

fi
