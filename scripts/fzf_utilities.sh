# various functions for using fzf
AURFILE="$HOME/.aur.dat"
PACFILE="$HOME/.pacman.dat"
alias fzkill="$HOME/dotfiles/scripts/fkill.sh"
alias fzkillall="$HOME/dotfiles/scripts/fkill.sh all"


##### ARCH PACKAGE MANAGEMENT
# TODO add expect keys to install, get info, list, check (-k),
# TODO make these zle functions? replace the buffer with the resulting command and run it?
fzpacmanall() { # all packages from official repos
  packages=($(pacman -Ss | grep -E '^(community|core|extra|multilib)\/' | cut -d' ' -f 1 | fzf -m | sed 's/.*\///'))
  [ -n "$packages" ] && pacman "${1--Sii}" $packages
}
fzpacman() { # installed packages from official repos
  packages=($(pacman -Qnq | fzf -m))
  [ -n "$packages" ] && pacman "${1--Qii}" $packages
}
fzaurall() { # all packages from aur
  packages=($(fzf -m < "$AURFILE"))
  [ -n "$packages" ] && pacaur "${1--Sii}" $packages
}
fzaur() { # installed packages from aur
  packages=($(pacman -Qmq | fzf -m))
  [ -n "$packages" ] && pacman "${1--Qii}" $packages
}
fzall() { # all packages on aur and in official repos
  local expect list selected key packages flags
  expect="ctrl-k,ctrl-l,ctrl-s,ctrl-o,ctrl-i"
  # TODO generate the list of all packages whenever one of the dbs changes
  # the db upgrade process is fucked to all hell, does multiple passes and shit
  # maybe just cron it semi regularly, it's an SSD access and about .2 seconds of computation
  list=$(sed 's/^/aur\//' $AURFILE; cat $PACFILE | cut -d' ' -f 1)
  selected=$(fzf -m --expect="$expect" <<< $list | cut -d/ -f2)

  key=$(head -1 <<< $selected)
  packages=$(sed '1d' <<< $selected)

  flags="-Sii"
  if [ "$key" = "ctrl-k" ]; then
    flags="-Qk"
  elif [ "$key" = "ctrl-l" ]; then
    flags="-Ql"
  elif [ "$key" = "ctrl-s" ]; then
    flags="-S"
  fi
  [ -n "$selected" ] && pacaur $flags $packages
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
  expect="ctrl-o" # TODO reverse this behavior? ctrl-o opens sequentially, default to opening all at once?
  while out=$(
      git log --color=always --graph --pretty=format:'%C(auto)%h %d %s %C(cyan)(%cr)%Creset [%C(97)%cn%Creset]' |
      fzf --ansi --multi --no-sort --reverse --query="$query" --print-query --expect="$expect"); do
    query=$(head -1 <<< "$out")
    keypress=$(sed -n '2p' <<< "$out")
    shalist=()
    while read sha; do
      if [ "$keypress" = "$expect" ]; then
        shalist+=$sha
      else
        [ -n "$sha" ] && git show --color=always $sha | less -R
      fi
    done < <(sed '1,2d;s/^[^a-z0-9]*//;/^$/d' <<< "$out" | awk '{print $1}')
    [ "$keypress" = "$expect" ] && git show --color $shalist
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
