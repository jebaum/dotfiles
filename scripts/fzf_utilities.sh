# various functions for using fzf
AURFILE="$HOME/.aur.dat"
PACFILE="$HOME/.pacman.dat"
alias fzkill="$HOME/dotfiles/scripts/fkill.sh"
alias fzkillall="$HOME/dotfiles/scripts/fkill.sh all"


##### ARCH PACKAGE MANAGEMENT
alias fzall='fzimpl all'             # packages from both repos and aur
alias fzpacmanall='fzimpl pacmanall' # packages from repos
alias fzaurall='fzimpl aurall'       # packages from aur
alias fzinstalled='fzimpl installed' # installed packages from both repos and aur
alias fzpacman='fzimpl pacman'       # installed packages from repos
alias fzaur='fzimpl aur'             # installed packages from aur

fzimpl() { # fzf package management implementation
  local expect list selected key packages flags filter pipe
  # figure out what subset of packages we want to select from
  if [ "$#" = "1" ]; then
    filter="$1"
  else
    filter="$WIDGET"
  fi

  if [ "$filter" = "all" ]; then
    # list=$(sed 's/^/aur\//' $AURFILE; pacman -Ss | grep -E '^(community|core|extra|multilib)\/')
    list=$(sed 's/^/aur\//' $AURFILE; cat $PACFILE)
  elif [ "$filter" = "pacmanall" ]; then
    # list=$(cat $PACFILE) # no version numbers, install status
    list=$(pacman -Ss | grep -E '^(community|core|extra|multilib)\/')
  elif [ "$filter" = "aurall" ]; then
    list=$(sed 's/^/aur\//' $AURFILE)
  elif [ "$filter" = "installed" ]; then
    list=$(pacman -Qnq; pacman -Qmq)
  elif [ "$filter" = "pacman" ]; then
    list=$(pacman -Qnq)
  elif [ "$filter" = "aur" ]; then
    list=$(pacman -Qmq)
  fi

  expect="ctrl-k,ctrl-l,ctrl-s,ctrl-r,alt-l"
  selected=$(fzf -m --expect="$expect" <<< $list | cut -d/ -f2 | cut -d' ' -f1)
  if [ -z "$selected" ]; then
    [ -n "$WIDGET" ] && zle reset-prompt
    return
  fi

  key=$(head -1 <<< $selected)
  packages=($(sed '1d' <<< $selected))

  flags="-Sii"
  if [ "$key" = "ctrl-k" ]; then
    flags="-Qk"
  elif [ "$key" = "ctrl-l" ]; then
    flags="-Ql"
  elif [ "$key" = "alt-l" ]; then
    flags="-Ql"
    pipe="| less"
  elif [ "$key" = "ctrl-s" ]; then
    flags="-S"
  elif [ "$key" = "ctrl-r" ]; then
    flags="-R"
  fi
  if [ -n "$selected" ]; then
    if [ -n "$WIDGET" ]; then
      BUFFER="pacaur $flags $packages $pipe"
      zle redisplay
      zle accept-line
    elif [ -n "$pipe" ]; then
      pacaur $flags $packages | less
    else
      pacaur $flags $packages
    fi
  fi
}


##### GIT
fzgbr() { # checkout git branch
  local branches branch
  branches=$(git branch) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout $(echo "$branch" | sed "s/.* //")
}

fzgbrall() { # checkout git branch (including remote branches)
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

fzgco() { # checkout git commit
  local commits commit
  commits=$(git log --color=always --graph --pretty=format:'%C(auto)%h %d %s %C(cyan)(%cr)%Creset [%C(97)%cn%Creset]') &&
  commit=$(echo "$commits" | fzf --ansi --no-sort --reverse +m) &&
  git checkout $(echo "$commit" | sed 's/^[^a-z0-9]*//' | awk '{print $1}')
}

fzgcotag() { # checkout git branch/tag
  local tags branches target
  tags=$(
    git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}') || return
  branches=$(
    git branch --all | grep -v HEAD             |
    sed "s/.* //"    | sed "s#remotes/[^/]*/##" |
    sort -u          | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}') || return
  target=$(
    (echo "$tags"; echo "$branches") |
    fzf-tmux -l30 -- --no-hscroll --ansi +m -d "\t" -n 2) || return
  git checkout $(echo "$target" | awk '{print $2}')
}

fzgshow() { # git commit browser. view all at once with ctrl-o, or sequentially with Enter
  local out sha query keypress expect
  expect="ctrl-o"
  while out=$(
      git log --color=always --graph --pretty=format:'%C(auto)%h %d %s %C(cyan)(%cr)%Creset [%C(97)%cn%Creset]' |
      fzf --ansi --multi --no-sort --reverse --query="$query" --print-query --expect="$expect"); do
    query=$(head -1 <<< "$out")
    keypress=$(sed -n '2p' <<< "$out")
    shalist=()
    while read sha; do
      # if ctrl-o was pressed, open each commit sequentially. else, open all at once
      if [ "$keypress" = "$expect" ]; then
        [ -n "$sha" ] && git show --color=always $sha | less -R
      else
        shalist+=$sha
      fi
    done < <(sed '1,2d;s/^[^a-z0-9]*//;/^$/d' <<< "$out" | awk '{print $1}')
    [ "$keypress" != "$expect" ] && git show --color $shalist
  done
}


##### FILES AND DIRECTORIES
fzcdf() { # change directory based on a file name
   local file
   local dir
   file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}
fzcd() { # change directory
  local dir
  dir=$(find ${1:-*} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}
fzcda() { # change directory, includes hidden directories
  local dir
  dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
}

fzlocate() { # open file from locate command
  local file
  file=$(locate "$1" | fzf)
  [ -n "$file" ] && ${EDITOR:-vim} "$file"
}

fzedit() { # edit a file
  local file
  file=$(fzf)
  [ -n "$file" ] && ${EDITOR:-vim} "$file"
}

fzopen() { # CTRL-O to open with `xdg-open` command, CTRL-E or Enter key to open with $EDITOR
  local out file key
  out=$(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && xdg-open "$file" || ${EDITOR:-vim} "$file"
  fi
}

fzviminfo() { # open files in ~/.viminfo
  local files
  files=$(grep '^>' ~/.viminfo | cut -c3- |
          while read line; do
            [ -f "${line/\~/$HOME}" ] && echo "$line"
          done | fzf-tmux -d -m -q "$*" -1) && vim ${files//\~/$HOME}
}


##### TMUX
fztmux() { # select a tmux session
  local session
  session=$(tmux list-sessions -F "#{session_name}" | \
    fzf) &&
  tmux switch-client -t "$session"
}

fztpane () { # switch pane
  local panes current_window target target_window target_pane
  panes=$(tmux list-panes -s -F '#I:#P - #{pane_current_path} #{pane_current_command}')
  current_window=$(tmux display-message  -p '#I')

  target=$(echo "$panes" | fzf) || return

  target_window=$(echo $target | awk 'BEGIN{FS=":|-"} {print$1}')
  target_pane=$(echo $target | awk 'BEGIN{FS=":|-"} {print$2}' | cut -c 1)

  if [[ $current_window -eq $target_window ]]; then
    tmux select-pane -t ${target_window}.${target_pane}
  else
    tmux select-pane -t ${target_window}.${target_pane} &&
    tmux select-window -t $target_window
  fi
}


##### SHELL
fzh() { # execute a thing from history
  eval $(([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}

fzhedit() { # put a thing from history on command line for editing. only works in zsh
  print -z $(([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}
