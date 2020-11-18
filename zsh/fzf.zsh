# keep in sync with https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh
export FZF_DEFAULT_OPTS="--extended --bind='alt-p:toggle-preview,alt-a:select-all,alt-d:deselect-all' --info=inline --color fg:#ebdbb2,hl:#FDB927,fg+:#ffffff,bg+:#552583,hl+:#fabd2f --color info:#83a598,prompt:#bdae93,spinner:#fabd2f,pointer:#FDB927,marker:#FDB927,header:#665c54"
export FZF_DEFAULT_COMMAND="rg --files -u 2>&1" # make sure errors are visible if there are any

if [[ $- == *i* ]]; then # $- is shell flags, 'i' flag means interactive shell

__fzfcmd() { # currently does basically nothing, can be used to change behavior of all commands easily
    echo "fzf"
}

# CTRL-T - Paste the selected file path(s) into the command line
__fsel() {
  # not using rg for this since I want directories listed as well, not just files
  local cmd="${FZF_CTRL_T_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
    -o -type f -print \
    -o -type d -print \
    -o -type l -print 2> /dev/null | cut -b3-"}"
  setopt localoptions pipefail no_aliases 2> /dev/null
  eval "$cmd" | FZF_DEFAULT_OPTS="--prompt='find . -mindepth 1 > ' --height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS" $(__fzfcmd) -m "$@" | while read item; do
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
fzf-history-widget() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null
  selected=( $(fc -rl 1 | perl -ne 'print if !$seen{(/^\s*[0-9]+\**\s+(.*)/, $1)}++' |
    FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort --reverse --query=${(qqq)LBUFFER} +m" $(__fzfcmd)) )
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

# Ensure precmds are run after cd
fzf-redraw-prompt() {
  local precmd
  for precmd in $precmd_functions; do
    $precmd
  done
  zle reset-prompt
}
zle -N fzf-redraw-prompt

# ALT-T - Paste the selected entry from find cache files I maintain into the command line
fzf-findcache-widget() {
LBUFFER="${LBUFFER}$(FZF_DEFAULT_OPTS="--prompt='findcache / > ' --height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS" $(__fzfcmd) -m < $HOME/.cache/allfilesanddirs.txt | while read item; do echo -n "${(q)item} "; done)"
  local ret=$?
  zle redisplay
  typeset -f zle-line-init >/dev/null && zle zle-line-init
  return $ret
}
zle     -N    fzf-findcache-widget
bindkey '\et' fzf-findcache-widget


# ALT-d and ALT-D - cd into the selected directory using find/findcache
fzf-cd-widget() {
  if [ "$1" = "find" ]; then
    local fzfprompt="find . -type d > "
    local cmd="command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
    -o -type d -print 2> /dev/null | cut -b3-"
  elif [ "$1" = "findcache" ]; then
    local fzfprompt="findcache > "
    if [ "$PWD" = "/" ]; then
      local cmd="cat ~/.cache/alldirs.txt"
    else
      # first line will always be exact match of $PWD, and will become blank after the cut. so tail +2 to return results starting from line 2
      local cmd="grep "$PWD" ~/.cache/alldirs.txt | cut -b $((${#PWD}+2))- | tail +2"
    fi
  fi

  setopt localoptions pipefail no_aliases 2> /dev/null
  local dir="$(eval "$cmd" | FZF_DEFAULT_OPTS="--prompt='$fzfprompt' --height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS" $(__fzfcmd) +m)"
  if [[ -z "$dir" ]]; then
    zle redisplay
    return 0
  fi
  if [ -z "$BUFFER" ]; then
    # UNRELATED NOTE - this line causes a highlighting bug in nvim-treesitter. opening quote doesn't seem to register as a quote
    # unless there's a space between it and the "=", but that changes the semantics
    BUFFER="cd ${(q)dir}" # " this fixes the highlighting lol. gives it a closing quote to match i guess
    zle accept-line
  else
    print -sr "cd ${(q)dir}"
    cd "$dir"
  fi
  local ret=$?
  unset dir # ensure this doesn't end up appearing in prompt expansion
  zle fzf-redraw-prompt
  return $ret
}
fzf-cd-widget-find() { fzf-cd-widget find }
fzf-cd-widget-findcache() { fzf-cd-widget findcache }
zle     -N    fzf-cd-widget-find
zle     -N    fzf-cd-widget-findcache
bindkey '^[d' fzf-cd-widget-find
bindkey '^[D' fzf-cd-widget-findcache

# CTRL-O and ALT-O - open file from rg or findcache
fzf-edit-widget() {
  local oldifs
  oldifs=$IFS
  IFS=$'\n'
  local OLD_FZF_DEFALUT_OPTS=$FZF_DEFAULT_OPTS
  FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS --bind=ctrl-r:toggle-sort --query=${(q)LBUFFER} -m"
  if [ "$1" = "rg" ]; then
    FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --prompt='rg > '"
    local filelist=( $(command rg --files 2>/dev/null | $(__fzfcmd)) )
  elif [ "$1" = "rg-all" ]; then
    FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --prompt='rg -u > '"
    local filelist=( $(command rg --files -u 2>/dev/null | $(__fzfcmd)) ) # includes hidden files
  elif [ "$1" = "findcache" ]; then
    FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --prompt='findcache / > '"
    local filelist=( $($(__fzfcmd) < $HOME/.cache/allfiles.txt) )
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
fzf-edit-widget-rg() { fzf-edit-widget rg }
fzf-edit-widget-rg-all() { fzf-edit-widget rg-all }
fzf-edit-widget-findcache() { fzf-edit-widget findcache }

zle -N fzf-edit-widget-rg
zle -N fzf-edit-widget-rg-all
zle -N fzf-edit-widget-findcache
bindkey '^O'   fzf-edit-widget-rg
bindkey '\eo'  fzf-edit-widget-rg-all
bindkey '\eO'  fzf-edit-widget-findcache

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

fi
