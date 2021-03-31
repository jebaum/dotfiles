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


##### GIT - TODO take a couple things from here https://github.com/wfxr/forgit (git add, stash, etc. I prefer my log viewer to theirs)
# also: https://github.com/jesseduffield/lazygit and https://github.com/wfxr/forgit
fzgbr() { # checkout git branch
  local branches branch
  branches=$(git --no-pager branch -vv) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
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
  commits=$(git log --pretty=oneline --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --tac +s +m -e) &&
  git checkout $(echo "$commit" | sed "s/ .*//")
}

fzgcotag() { # checkout git branch/tag
  local tags branches target
  branches=$(
    git --no-pager branch --all \
      --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" \
    | sed '/^$/d') || return
  tags=$(
    git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}') || return
  target=$(
    (echo "$branches"; echo "$tags") |
    fzf --no-hscroll --no-multi -n 2 \
        --ansi) || return
  git checkout $(awk '{print $2}' <<<"$target" )
}

# for fzgshow and fzgsha - need to explicitly pipe to delta | less so the pager doesn't immediately quit (--quit-if-one-screen doesn't have an off flag for some stupid fucking reason)
# `delta --navigate' also seems to work since it forces the pager to stay active on the screen in order to use the search pattern, but leaves the screen with junk on it afterward
# `delta --side-by-side' doesn't work due to weird interactions with the pager i don't care enough to figure out
# i explicitly pass `--line-numbers --features decorations' to delta to turn off side-by-side, which is turned on by default in gitconfig since i want it on for `git diff'
fzgshow() { # git commit browser
  local out sha query keypress expect
  expect="ctrl-o"
  while out=$(
      git log --color=always --pretty=format:'%C(auto)%h %d %s %C(cyan)(%cr)%Creset [%C(97)%cn%Creset]' $@ |
        fzf --header "enter: multiple commits at once | ctrl-o: sequential | ctrl-y: copy short hash | ctrl-g: copy full hash" \
            --ansi --multi --no-sort --reverse --query="$query" --print-query --expect="$expect" --preview="git show --color=always {1} | delta --features decorations" \
            --bind 'ctrl-y:execute-silent(echo -n {} | grep -o "[a-f0-9]\{7\}" | head -1 | tr -d "\n" | xclip -selection clipboard)+abort' \
            --bind 'ctrl-g:execute-silent(echo -n {} | grep -o "[a-f0-9]\{7\}" | xargs git rev-parse | head -1 | tr -d "\n" | xclip -selection clipboard)+abort' \
        ); do
    query=$(echo "$out" | head -1)
    keypress=$(echo "$out" | sed -n '2p')
    shalist=()
    while read sha; do
      if [ "$keypress" = "$expect" ]; then
        [ -n "$sha" ] && git show --color=always $sha | delta --line-numbers --features decorations | less
      else
        shalist+=$sha
      fi
    done < <(echo "$out" | sed '1,2d;s/^[^a-z0-9]*//;/^$/d' | awk '{print $1}')
    [ "$keypress" != "$expect" ] && git show --color=always $shalist | delta --line-numbers --features decorations | less
  done
}


# fzgsha - get git commit sha, copy to clipboard
# example usage: git rebase -i `fzgsha`
_gitLogLineToHash="echo {} | grep -o '[a-f0-9]\{7\}' | head -1"
_viewGitLogLine="$_gitLogLineToHash | xargs -I % sh -c 'git show --color=always %' | delta --features decorations"
fzgsha() {
    git log --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr% C(auto)%an" "$@" |
        fzf --no-sort --reverse --tiebreak=index --no-multi \
            --ansi --preview="$_viewGitLogLine" \
                --header "ctrl-o to view, ctrl-y to copy short hash, ctrl-g to copy full hash" \
                --bind "ctrl-o:execute:$_viewGitLogLine | less -R" \
                --bind 'ctrl-y:execute-silent(echo -n {} | grep -o "[a-f0-9]\{7\}" | head -1 | tr -d "\n" | xclip -selection clipboard)+abort' \
                --bind 'ctrl-g:execute-silent(echo -n {} | grep -o "[a-f0-9]\{7\}" | xargs git rev-parse | head -1 | tr -d "\n" | xclip -selection clipboard)+abort'
}

# fzgstash - easier way to deal with stashes
# type fstash to get a list of your stashes
# enter shows you the contents of the stash
# ctrl-d shows a diff of the stash against your current HEAD
# ctrl-b checks the stash out as a branch, for easier merging
# TODO currently only works in bash due to `mapfile`
fzgstash() {
  local out q k sha
  while out=$(
    git stash list --pretty="%C(yellow)%h %>(14)%Cgreen%cr %C(blue)%gs" |
      fzf --header "enter: show stash, ctrl-d: diff stash HEAD, ctrl-b: check stash out as branch (easier merging)" --ansi --no-sort --query="$q" --print-query \
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

# https://seb.jambor.dev/posts/improving-shell-workflows-with-fzf/#pull-requests
function fzprcheckout() {
  local jq_template pr_number

  jq_template='"'\
'#\(.number) - \(.title)'\
'\t'\
'Author: \(.user.login)\n'\
'Created: \(.created_at)\n'\
'Updated: \(.updated_at)\n\n'\
'\(.body)'\
'"'

  pr_number=$(
    gh api 'repos/:owner/:repo/pulls' |
    jq ".[] | $jq_template" |
    sed -e 's/"\(.*\)"/\1/' -e 's/\\t/\t/' |
    fzf \
      --with-nth=1 \
      --delimiter='\t' \
      --preview='echo -e {2}' \
      --preview-window=top:wrap |
    sed 's/^#\([0-9]\+\).*/\1/'
  )

  if [ -n "$pr_number" ]; then
    gh pr checkout "$pr_number"
  fi
}

function fzprdiff() {
  gh pr list | fzf --preview "gh pr diff --color=always {+1}"
}
