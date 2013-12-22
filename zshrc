# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="blinks"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
 DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
 COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git archlinux autojump colored-man extract web-search) # zsh-syntax-highlighting)
# ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
# left off on git

source $ZSH/oh-my-zsh.sh
source ~/.aliases
source ~/dotfiles/scripts/bd.zsh
source ~/dotfiles/scripts/zbell.zsh
source ~/dotfiles/prompt.zsh

setopt BRACE_CCL
setopt NO_CASE_GLOB
setopt NUMERIC_GLOB_SORT
export EDITOR=vim
export PAGER="less"
export LESS="-R"
if [ -f "/usr/bin/src-hilite-lesspipe.sh" ]; then
  export LESSOPEN="| /usr/bin/src-hilite-lesspipe.sh %s"
fi

stty -ixon  # stop C-s from activating scroll lock
ulimit -c unlimited

GPG_TTY=$(tty)
export GPG_TTY

insert_sudo () { zle beginning-of-line; zle -U "sudo " }
zle -N insert-sudo insert_sudo
# list of actions here http://www.cs.elte.hu/zsh-manual/zsh_14.html
bindkey "^[[7~" beginning-of-line   # make home key work
bindkey "^[[8~" end-of-line         # make end key work
bindkey "^J"    backward-word       # C-j moves back a word
bindkey "^L"    forward-word        # C-l moves forward a word
bindkey "^[j"   backward-char       # A-j moves back a character
bindkey "^[l"   forward-char        # A-l moves forward a character
bindkey "^[S"   clear-screen        # Alt+Shift+S to do what ^l does by default, clear screen
bindkey "^F"    vi-find-next-char   # C-f takes one character input, moves to next instance
bindkey "^D"    vi-find-prev-char   # C-d takes one character input, moves to prev instance
bindkey "^T"    vi-repeat-find      # C-t repeats last find
bindkey "^S"    insert-sudo         # C-s inserts 'sudo' at beginning of line
bindkey "^Q"    delete-word         # C-q deletes word in front of cursor, opposite C-w
bindkey "^G"    delete-char         # C-g deletes character in front of cursor, opposite C-h
bindkey "^B"    undo                # C-b undoes last text modification (think 'back')
bindkey "^V"    send-break          # C-v aborts current command
# ^Y is available for a bind
