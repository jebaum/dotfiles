# various functions for using fzf
# keep in sync with https://github.com/junegunn/fzf/wiki/Examples
AURFILE="$HOME/.aur.dat"
PACFILE="$HOME/.pacman.dat"
alias fzkill="$HOME/dotfiles/scripts/fkill.sh"
alias fzkillall="$HOME/dotfiles/scripts/fkill.sh -9 all"


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
  selected=$(echo $list | fzf -m --expect="$expect" | cut -d/ -f2 | cut -d' ' -f1)
  if [ -z "$selected" ]; then
    [ -n "$WIDGET" ] && zle reset-prompt
    return
  fi

  key=$(echo $selected | head -1)
  packages=($(echo $selected | sed '1d'))

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
      BUFFER="yay $flags $packages $pipe"
      zle redisplay
      zle accept-line
    elif [ -n "$pipe" ]; then
      yay $flags $packages | less
    else
      yay $flags $packages
    fi
  fi
}


##### GIT
fzgbr() { # checkout git branch
  local branches branch
  branches=$(git branch -vv) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

fzgbrall() { # checkout git branch (including remote branches)
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(echo "$branches" | wc -l) )) +m) &&
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
      git log --color=always --pretty=format:'%C(auto)%h %d %s %C(cyan)(%cr)%Creset [%C(97)%cn%Creset]' $@ |
      fzf --bind='ctrl-space:toggle-preview' --ansi --multi --no-sort --reverse --query="$query" --print-query --expect="$expect" --preview="git show --color=always {1}"); do
    query=$(echo "$out" | head -1)
    keypress=$(echo "$out" | sed -n '2p')
    shalist=()
    while read sha; do
      # if ctrl-o was pressed, open each commit sequentially. else, open all at once
      if [ "$keypress" = "$expect" ]; then
        [ -n "$sha" ] && git show --color=always $sha | less -R
      else
        shalist+=$sha
      fi
    done < <(echo "$out" | sed '1,2d;s/^[^a-z0-9]*//;/^$/d' | awk '{print $1}')
    [ "$keypress" != "$expect" ] && git show --color $shalist
  done
}

# fzgsha - get git commit sha, copy to clipboard
# example usage: git rebase -i `fzgsha`
fzgsha() {
  local commits commit long
  if [ "$1" = "long" ]; then
      long=""
  else
      long="--abbrev-commit"
  fi
  commits=$(git log --color=always --pretty=oneline $long --reverse) &&
  commit=$(echo "$commits" | fzf --tac +s +m --ansi --reverse --nth=2..) &&
  echo -n $(echo "$commit" | sed "s/ .*//" | xargs git rev-parse) | xsel # git rev-parse will get the full hash
  echo "full hash from \`$commit' copied to clipboard"
}

# fzgstash - easier way to deal with stashes
# type fstash to get a list of your stashes
# enter shows you the contents of the stash
# ctrl-d shows a diff of the stash against your current HEAD
# ctrl-b checks the stash out as a branch, for easier merging
# TODO make a repo to test this in, make sure eliminating the <<< redirection in favor of echo doesn't break it
fzgstash() {
  local out q k sha
  while out=$(
    git stash list --pretty="%C(yellow)%h %>(14)%Cgreen%cr %C(blue)%gs" |
    fzf --ansi --no-sort --query="$q" --print-query \
        --expect=ctrl-d,ctrl-b);
  do
    mapfile -t out <<< "$out"
    q="${out[0]}"
    k="${out[1]}"
    sha="${out[-1]}"
    sha="${sha%% *}"
    [[ -z "$sha" ]] && continue
    if [[ "$k" == 'ctrl-d' ]]; then
      git diff $sha
    elif [[ "$k" == 'ctrl-b' ]]; then
      git stash branch "stash-$sha" $sha
      break;
    else
      git stash show -p $sha
    fi
  done
}


##### FILES AND DIRECTORIES
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
fzcdf() { # change directory based on a file name
   local file
   local dir
   file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}
fzcdlocate() {
  local file
  file="$(locate -Ai -0 "${@:-$HOME}" | grep -z -vE '~$' | fzf --read0 -0 -1)"
  if [[ -n $file ]]
  then
     if [[ -d $file ]]
     then
        cd -- $file
     else
        cd -- ${file:h}
     fi
  fi
}
fzlocate() { # open file from locate command
  local files
  files=($(locate -Ai -0 "${@:-$HOME}" | grep -z -vE '~$' | fzf --read0 -0 -1 -m))
  [[ -n "$files" ]] && ${EDITOR:-vim} -p "${files[@]}"; print -l $files
}
fzedit() { # edit a file
  local files
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-vim} -p "${files[@]}"; print -l $files
}
fzopen() { # CTRL-O to open with `xdg-open` command, CTRL-E or Enter key to open with $EDITOR
  local out file key
  IFS=$'\n' out=($(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e,enter))
  key=$(echo "$out" | head -1)
  file=$(echo "$out" | sed -n '2p')
  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} "$file"
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
    fzf --query="$1" --select-1 --exit-0) &&
  tmux switch-client -t "$session"
}

fztpane () { # switch pane
# In tmux.conf: bind-key 0 run "tmux split-window -l 12 'bash -ci fztpane'"
  local panes current_window current_pane target target_window target_pane
  panes=$(tmux list-panes -s -F '#I:#P - #{pane_current_path} #{pane_current_command}')
  current_pane=$(tmux display-message -p '#I:#P')
  current_window=$(tmux display-message -p '#I')

  target=$(echo "$panes" | grep -v "$current_pane" | fzf +m --reverse) || return

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
