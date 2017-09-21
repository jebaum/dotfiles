# keep in sync with https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh
export FZF_DEFAULT_OPTS="--extended --bind='ctrl-space:toggle-preview,alt-a:select-all,alt-d:deselect-all' --inline-info --color fg:-1,bg:-1,hl:80,fg+:3,bg+:233,hl+:46,info:150,prompt:110,spinner:150,pointer:167,marker:174"

if [[ $- == *i* ]]; then # $- is shell flags, 'i' flag means interactive shell

__fzfcmd() { # currently does basically nothing, can be used to change behavior of all commands easily
    echo "fzf"
}

# CTRL-T - Paste the selected file path(s) into the command line
__fsel() {
  local cmd="${FZF_CTRL_T_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
    -o -type f -print \
    -o -type d -print \
    -o -type l -print 2> /dev/null | cut -b3-"}"
  setopt localoptions pipefail 2> /dev/null
  eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" $(__fzfcmd) -m "$@" | while read item; do
    echo -n "${(q)item} "
  done
  local ret=$?
  echo
  return $ret
}
fzf-file-widget() {
  LBUFFER="${LBUFFER}$(__fsel)"
  local ret=$?
  zle redisplay
  typeset -f zle-line-init >/dev/null && zle zle-line-init
  return $ret
}
zle     -N   fzf-file-widget
bindkey '^T' fzf-file-widget

# ALT-T - Paste the selected entry from locate output into the command line
fzf-locate-widget() {
LBUFFER="${LBUFFER}$(locate / | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS" $(__fzfcmd) -m | while read item; do echo -n "${(q)item} "; done)"
  local ret=$?
  zle redisplay
  typeset -f zle-line-init >/dev/null && zle zle-line-init
  return $ret
}
zle     -N    fzf-locate-widget
bindkey '\et' fzf-locate-widget


# ALT-d and ALT-D - cd into the selected directory using find/locate
fzf-cd-find-widget() {
  local cmd="${FZF_ALT_C_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
    -o -type d -print 2> /dev/null | cut -b3-"}"
  setopt localoptions pipefail 2> /dev/null
  local dir="$(eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS" $(__fzfcmd) +m)"
  if [[ -z "$dir" ]]; then
    zle redisplay
    return 0
  fi
  cd "$dir"
  local ret=$?
  zle reset-prompt
  typeset -f zle-line-init >/dev/null && zle zle-line-init
  return $ret
}

fzf-cd-locate-widget() {
  # $PWD will be expanded inside sed, so use a nonprinting bullshit character
  # as sed delimiter to make sure the whatever $PWD is doesn't screw up the command
  # DIR="${$(strings /var/lib/mlocate/mlocate.db | grep "^/" 2>/dev/null | sed "s^${PWD}/" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse" $(__fzfcmd)):-.}"
  DIR="${$(strings /var/lib/mlocate/mlocate.db | grep "^/" 2>/dev/null | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse" $(__fzfcmd)):-.}"
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
  setopt localoptions noglobsubst noposixbuiltins pipefail 2> /dev/null
  selected=( $(fc -l 1 |
    FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS --tac -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort $FZF_CTRL_R_OPTS --query=${(q)LBUFFER} +m" $(__fzfcmd)) )
  local ret=$?
  if [ -n "$selected" ]; then
    num=$selected[1]
    if [ -n "$num" ]; then
      zle vi-fetch-history -n $num
    fi
  fi
  zle redisplay
  typeset -f zle-line-init >/dev/null && zle zle-line-init
  return $ret
}

zle     -N   fzf-history-widget
bindkey '^R' fzf-history-widget


# CTRL-O and ALT-O - open file from ag/locate commands
# TODO determine whether to use ag or rg based on rg availability
fzf-edit-widget-rg() { fzf-edit-widget rg }
fzf-edit-widget-rg-all() { fzf-edit-widget rg-all }
fzf-edit-widget-locate() { fzf-edit-widget locate }

fzf-edit-widget() {
  local oldifs
  oldifs=$IFS
  IFS=$'\n'
  local OLD_FZF_DEFALUT_OPTS=$FZF_DEFAULT_OPTS
  FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS --bind=ctrl-r:toggle-sort --query=${(q)LBUFFER} -m"
  if [ "$1" = "rg" ]; then
    local filelist=( $(command rg -g '' --files 2>/dev/null | $(__fzfcmd)) )
    # local filelist=( $(ag -g '.' 2>/dev/null | $(__fzfcmd)) )
  elif [ "$1" = "rg-all" ]; then
    local filelist=( $(command rg -g '*' --files 2>/dev/null | $(__fzfcmd)) )
  elif [ "$1" = "locate" ]; then
    local filelist=( $(locate / 2>/dev/null | $(__fzfcmd)) )
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
  FZF_DEFAULT_OPTS=$OLD_FZF_DEFALUT_OPTS
}

zle -N fzf-edit-widget-rg
bindkey '^O'   fzf-edit-widget-rg

zle -N fzf-edit-widget-rg-all
bindkey '\eo'  fzf-edit-widget-rg-all

zle -N fzf-edit-widget-locate
bindkey '\eO'  fzf-edit-widget-locate

fzgshowkey() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        fzgshow
    fi
    zle redisplay
}
zle -N fzgshowkey fzgshowkey
bindkey '\es' fzgshowkey


# TODO determine whether to use ag or rg based on rg availability
fzf-search-widget() {
    # rg '[^:]+:[0-9]+:.{5,}'   # matches lines with 5 characters or more after the metadata
    # rg '[^:]+:[0-9]+:$'       # matches empty lines
    # filelist=($(ag "." --nocolor 2>/dev/null | grep -Ev ':[0-9]+:$' | fzf -m | cut -f 1,2 -d ":" | tr '\n' ' '))
    if [ "$1" = "rg-all" ]; then
        local UARGS="-u"
    elif [ "$1" = "rg-all-hidden" ]; then
        local UARGS="-uu"
    else
        local UARGS=""
    fi
    filelist=($(command rg ".{7,}" $UARGS --color never --line-number 2>/dev/null | $(__fzfcmd) -m | cut -f 1,2 -d ":" | tr '\n' ' '))
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
}
fzf-search-widget-rg() { fzf-search-widget rg }
zle -N fzf-search-widget-rg
bindkey "^X" fzf-search-widget-rg

fzf-search-widget-rg-all() { fzf-search-widget rg-all }
zle -N fzf-search-widget-rg-all
bindkey "\ex" fzf-search-widget-rg-all

fzf-search-widget-rg-all-hidden() { fzf-search-widget rg-all-hidden }
zle -N fzf-search-widget-rg-all-hidden
bindkey "\eX" fzf-search-widget-rg-all-hidden


brazilwscd() {
    if [ ! -d "$HOME/workspace" ]; then
        return
    fi
    local WS=$(find $HOME/workspace -maxdepth 3 -type d -path '*src/*' | sed "s|$HOME/workspace/||" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-75%} --reverse $FZF_DEFAULT_OPTS" $(__fzfcmd) --delimiter="/" --nth=1,3..)
    if [ -n "$WS" ] && [ -d "$HOME/workspace/$WS" ]; then
        cd "$HOME/workspace/$WS"
    fi
    if [ -n "$WIDGET" ]; then
        zle reset-prompt
    fi
}
zle -N brazilwscd brazilwscd
bindkey "\ew" brazilwscd # Alt + w


# zle -N <widget name> <function name>
zle -N all fzimpl
zle -N installed fzimpl
bindkey '\ep' all
bindkey '\eP' installed

fi
