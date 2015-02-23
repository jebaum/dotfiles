# various functions for using fzf
# TODO make sure to be using multiple selection, -e exact and -x regex matchings when convenient. maybe should allow passing -e and -x
# for searching packages, maybe want regex + exact

AURFILE="$HOME/.aur.dat"
PACFILE="$HOME/.pacman.dat"

alias fkill="$HOME/dotfiles/scripts/fkill.sh"
alias fkillall="$HOME/dotfiles/scripts/fkill.sh all"

# TODO make an alias for all packages, which will use sed in a loop to prepend 'aur/' to $AURFILE
# TODO also just think about these in general, would like to not have as many of them
# TODO also rework these so that C-c after invoking it doesn't spit everything to the terminal
# TODO there's an aurpkglist command provided by python3-aur package
fpacmanall() {
  pacman "${1--Sii}" $(fzf --query="$2" --select-1 --exit-0 < "$PACFILE")
}
faurall() {
  pacaur "${1--ii}" $(fzf --query="$2" --select-1 --exit-0 < "$AURFILE")
}
fpacman() {
  pacman "${1--Qii}" $(pacman -Qnq | fzf --query="$2" --select-1 --exit-0)
}
faur() {
  pacman "${1--Qii}" $(pacman -Qmq | fzf --query="$2" --select-1 --exit-0)
}
fpacall() {
  local paclist aurlist
  list=$(sed 's/^/aur\//' $AURFILE; cat $PACFILE)
  selected=$(echo "$list" | fzf -e | cut -d/ -f2)
  # pacman "${1--Qii}"
}


fl() { # open file from locate command
  local file
  file=$(locate "$1" | fzf --select-1 --exit-0)
  [ -n "$file" ] && ${EDITOR:-vim} "$file"
}

fbr() { # checkout branch
  local branches branch
  branches=$(git branch --verbose | sed 's/^[ \t]*//') &&
  branch=$(echo "$branches" | fzf +s +m) &&
  git checkout $(echo "$branch" | sed "s/.* //")
}

fco() { # checkout commit or branch
  local commits commit
  commits=$(git log --pretty=oneline --abbrev-commit --reverse; git branch --verbose | sed 's/^[ \t]*//') &&
  commit=$(echo "$commits" | fzf +s +m -e) &&
  git checkout $(echo "$commit" | sed "s/ .*//")
}

ftmux() { # select a tmux session
  local session
  session=$(tmux list-sessions -F "#{session_name}" | \
    fzf --query="$1" --select-1 --exit-0) &&
  tmux switch-client -t "$session"
}

fj() { # for using z, provided by z-git in the aur
  if [[ -z "$*" ]]; then
    cd "$(_z -l 2>&1 | sed -n 's/^[ 0-9.,]*//p' | fzf)"
  else
    _z "$@"
  fi
}

# Here is another version that also supports relaunching z with the arguments for the previous command as the default input by using zz
fz() {
  if [[ -z "$*" ]]; then
    cd "$(_z -l 2>&1 | sed -n 's/^[ 0-9.,]*//p' | fzf)"
  else
    _last_z_args="$@"
    _z "$@"
  fi
}
fzz() {
  cd "$(_z -l 2>&1 | sed -n 's/^[ 0-9.,]*//p' | fzf -q $_last_z_args)"
}

cdf() { # change directory based on a file name
   local file
   local dir
   file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}
fd() { # change directory
  local dir
  dir=$(find ${1:-*} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}
fda() { # change directory, includes hidden directories
  local dir
  dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
}
fe() { # edit a file
  local file
  file=$(fzf --query="$1" --select-1 --exit-0)
  [ -n "$file" ] && ${EDITOR:-vim} "$file"
}

fh() { # execute a thing from history
  eval $(([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s | sed 's/ *[0-9]* *//')
}

fhedit() { # put a thing from history on command line for editing. only works in zsh
  print -z $(([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s | sed 's/ *[0-9]* *//')
}
