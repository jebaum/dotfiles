# keep in sync with https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh
export FZF_DEFAULT_OPTS="--ansi --extended --bind='alt-p:toggle-preview,alt-a:select-all,alt-d:deselect-all,ctrl-r:toggle-sort' --info=inline --color fg:#ebdbb2,hl:#FDB927,fg+:#ffffff,bg+:#552583,hl+:#fabd2f --color info:#83a598,prompt:#bdae93,spinner:#fabd2f,pointer:#FDB927,marker:#FDB927,header:#665c54"

export FZF_DEFAULT_COMMAND='command fd --no-ignore-vcs --type file --hidden --exclude .git --exclude /sys --exclude /proc --exclude /var/lib/plex'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

if [[ $- == *i* ]]; then # $- is shell flags, 'i' flag means interactive shell

__fzfcmd() { # currently does basically nothing, can be used to change behavior of all commands easily
    echo "fzf"
}

# CTRL-T - Paste the selected file path(s) into the command line
__fsel() {
  local REPORTTIME=-1 # make sure zsh doesn't dump time stats into the fzf prompt if it takes too long to finish
  local cmd="${FZF_CTRL_T_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
    -o -type f -print \
    -o -type d -print \
    -o -type l -print 2> /dev/null | cut -b3-"}"
  setopt localoptions pipefail no_aliases 2> /dev/null
  local FZF_CTRL_T_OPTS="$FZF_DEFAULT_OPTS --prompt='find . -mindepth 1 > ' --height ${FZF_TMUX_HEIGHT:-40%} --reverse -m"
  eval "$cmd" | FZF_DEFAULT_OPTS="$FZF_CTRL_T_OPTS" $(__fzfcmd) "$@" | while read item; do
    echo -n "${(q)item} "
  done
  local ret=$?
  echo
  return $ret
}

fzf-file-widget() {
  LBUFFER="${LBUFFER}$(__fsel)"
  local ret=$?
  zle reset-prompt
  return $ret
}
zle     -N   fzf-file-widget
bindkey '^T' fzf-file-widget

# CTRL-R - Paste the selected command from history into the command line
# https://github.com/junegunn/fzf/issues/1431 - copy execution may require a sleep? seems to work fine for me without it
fzf-history-widget() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null
  local FZF_CTRL_R_OPTS="$FZF_DEFAULT_OPTS --height ${FZF_TMUX_HEIGHT:-40%} -n2..,.. --tiebreak=index --bind 'ctrl-y:execute-silent(echo -n {2..} | xclip -selection clipboard)+abort' --reverse --header 'Press CTRL-Y to copy command into clipboard' --query=${(qqq)LBUFFER} +m"
  selected=( $(fc -rl 1 | perl -ne 'print if !$seen{(/^\s*[0-9]+\**\s+(.*)/, $1)}++' | FZF_DEFAULT_OPTS="$FZF_CTRL_R_OPTS" $(__fzfcmd)) )
  local ret=$?
  if [ -n "$selected" ]; then
    num=$selected[1]
    if [ -n "$num" ]; then
      zle vi-fetch-history -n $num
    fi
  fi
  zle reset-prompt
  return $ret
}

zle     -N   fzf-history-widget
bindkey '^R' fzf-history-widget


# ALT-d and ALT-D - cd into the selected directory using fd
fzf-cd-widget() {
  local REPORTTIME=-1
  if [ "$1" = "fd" ]; then
    local fzfprompt="fd --type d > "
    local cmd="fd --type d"
  elif [ "$1" = "fdhidden" ]; then
    local fzfprompt="fd --type d --hidden > "
    local cmd="fd --type d --hidden --exclude .git"
  fi

  setopt localoptions pipefail no_aliases 2> /dev/null
  local FZF_ALT_D_OPTS="$FZF_DEFAULT_OPTS --prompt='$fzfprompt' --height ${FZF_TMUX_HEIGHT:-40%} --reverse +m"
  local dir="$(eval "$cmd" | FZF_DEFAULT_OPTS="$FZF_ALT_D_OPTS" $(__fzfcmd))"
  if [[ -z "$dir" ]]; then
    zle redisplay
    return 0
  fi
  zle push-line
  BUFFER="cd ${(q)dir}" # " this fixes the highlighting lol. gives it a closing quote to match i guess. comment color is still wrong though
  zle accept-line
  local ret=$?
  unset dir # ensure this doesn't end up appearing in prompt expansion
  zle reset-prompt
  return $ret
}
fzf-cd-widget-fd() { fzf-cd-widget fd }
fzf-cd-widget-fdhidden() { fzf-cd-widget fdhidden }
zle     -N    fzf-cd-widget-fd
zle     -N    fzf-cd-widget-fdhidden
bindkey '^[d' fzf-cd-widget-fd
bindkey '^[D' fzf-cd-widget-fdhidden

# CTRL-O and ALT-O - open file from fd
fzf-edit-widget() {
  local REPORTTIME=-1
  local oldifs
  oldifs=$IFS
  IFS=$'\n'
  local OLD_FZF_DEFALUT_OPTS=$FZF_DEFAULT_OPTS
  FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --height ${FZF_TMUX_HEIGHT:-40%} --reverse --query=${(q)LBUFFER} -m"
  if [ "$1" = "fd" ]; then
    FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --prompt='fd --type f > '"
    local filelist=( $(command fd --type f | $(__fzfcmd)) )
  elif [ "$1" = "fdhidden" ]; then
    FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --prompt='fd --no-ignore-vcs --type f --hidden > '"
    local filelist=( $(command fd --no-ignore-vcs --type f --hidden --exclude .git | $(__fzfcmd)) )
  elif [ "$1" = "fdall" ]; then
    FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --prompt='fd / --no-ignore-vcs --type f --hidden > '"
    local filelist=( $(command fd . '/' --no-ignore-vcs --type f --hidden --exclude .git --exclude /sys --exclude /proc | $(__fzfcmd)) )
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
fzf-edit-widget-fd() { fzf-edit-widget fd }
fzf-edit-widget-fdhidden() { fzf-edit-widget fdhidden }
fzf-edit-widget-fdall() { fzf-edit-widget fdall }

zle -N fzf-edit-widget-fd
zle -N fzf-edit-widget-fdhidden
zle -N fzf-edit-widget-fdall
bindkey '^O'   fzf-edit-widget-fd
bindkey '\eo'  fzf-edit-widget-fdhidden
bindkey '\eO'  fzf-edit-widget-fdall

fzgshowkey() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        fzgshow
    fi
    zle redisplay
}
zle -N fzgshowkey fzgshowkey
bindkey '\es' fzgshowkey


fzf-search-widget() {
    # rg '[^:]+:[0-9]+:.{5,}'   # matches lines with 5 characters or more after the metadata
    # rg '[^:]+:[0-9]+:$'       # matches empty lines
    # filelist=($(ag "." --nocolor 2>/dev/null | grep -Ev ':[0-9]+:$' | fzf -m | cut -f 1,2 -d ":" | tr '\n' ' '))
    local OLD_FZF_DEFALUT_OPTS=$FZF_DEFAULT_OPTS
    if [ "$1" = "rg-all" ]; then
        FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --prompt='rg -u ".{5,}" > '"
        local UARGS="-u"
    elif [ "$1" = "rg-all-hidden" ]; then
        FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --prompt='rg -uu ".{5,}" > '"
        local UARGS="-uu"
    else
        FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --prompt='rg ".{5,}" > '"
        local UARGS=""
    fi
    filelist=($(command rg ".{5,}" $UARGS --color never --line-number 2>/dev/null | $(__fzfcmd) -m | cut -f 1,2 -d ":" | tr '\n' ' '))
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
    FZF_DEFAULT_OPTS=$OLD_FZF_DEFALUT_OPTS
}
fzf-search-widget-rg() { fzf-search-widget rg }
fzf-search-widget-rg-all() { fzf-search-widget rg-all }
fzf-search-widget-rg-all-hidden() { fzf-search-widget rg-all-hidden }
zle -N fzf-search-widget-rg
zle -N fzf-search-widget-rg-all
zle -N fzf-search-widget-rg-all-hidden
bindkey "^X" fzf-search-widget-rg
bindkey "\ex" fzf-search-widget-rg-all
bindkey "\eX" fzf-search-widget-rg-all-hidden


# zle -N <widget name> <function name>
zle -N all fzimpl
zle -N installed fzimpl
bindkey '\ep' all
bindkey '\eP' installed


monorepocd() {
    local LOCATION="$HOME/work/dev/code"
    if [ ! -d "$LOCATION" ]; then
        return
    fi
    local WS=$(fd . --type d $LOCATION | sed "s|$LOCATION/||" | sort | sed -e '1 i .' | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-75%} --reverse $FZF_DEFAULT_OPTS" $(__fzfcmd))
    if [ -n "$WS" ] && [ -d "$LOCATION/$WS" ]; then
        cd "$LOCATION/$WS"
        saved_buffer=$BUFFER
        saved_cursor=$CURSOR
        BUFFER=
        zle accept-line
    fi
    if [ -n "$WIDGET" ]; then
        zle reset-prompt
    fi
}
zle -N monorepocd monorepocd
bindkey "\ew" monorepocd # Alt + w

fi
