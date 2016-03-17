# keep in sync with https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh
export FZF_DEFAULT_OPTS="-x --inline-info --color fg:-1,bg:-1,hl:80,fg+:3,bg+:233,hl+:46,info:150,prompt:110,spinner:150,pointer:167,marker:174"

if [[ $- == *i* ]]; then # $- is shell flags, 'i' flag means interactive shell

# CTRL-T - Paste the selected file path(s) into the command line
__fsel() {
  local cmd="${FZF_CTRL_T_COMMAND:-"command find -L . \\( -path '*/\\.*' -o -fstype 'dev' -o -fstype 'proc' \\) -prune \
    -o -type f -print \
    -o -type d -print \
    -o -type l -print 2> /dev/null | sed 1d | cut -b3-"}"
  eval "$cmd" | $(__fzfcmd) -m | while read item; do
    printf '%q ' "$item"
  done
  echo
}

__fzfcmd() {
  [ ${FZF_TMUX:-1} -eq 1 ] && echo "fzf-tmux -d${FZF_TMUX_HEIGHT:-40%}" || echo "fzf"
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
  local cmd="${FZF_ALT_C_COMMAND:-"command find -L . \\( -path '*/\\.*' -o -fstype 'dev' -o -fstype 'proc' \\) -prune \
    -o -type d -print 2> /dev/null | sed 1d | cut -b3-"}"
  cd "${$(eval "$cmd" | $(__fzfcmd) +m):-.}"
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
  local selected num
  selected=( $(fc -l 1 | $(__fzfcmd) +s --tac +m -n2..,.. --tiebreak=index --toggle-sort=ctrl-r -q "${LBUFFER//$/\\$}") )
  if [ -n "$selected" ]; then
    num=$selected[1]
    if [ -n "$num" ]; then
      zle vi-fetch-history -n $num
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
    local filelist=( $(ag -g '.' 2>/dev/null | fzf -m) )
  elif [ "$1" = "locate" ]; then
    local filelist=( $(locate --wholename "$PWD" 2>/dev/null | fzf -m) )
  fi
  if [ -z "$filelist" ]; then
    zle redisplay
  else
    local opencmd="${EDITOR} -p "
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
