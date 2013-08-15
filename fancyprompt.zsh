# -*- mode: sh; -*-
# Rivo prompt set-up

local __GIT_PROMPT_DIR=~/dotfiles/scripts # directory containing python file

setopt prompt_subst # Allow for functions in the prompt

# Enable auto-execution of functions
typeset -ga preexec_functions
typeset -ga precmd_functions
typeset -ga chpwd_functions

# Executed before each prompt
precmd_functions+='precmd_update_git_vars'
# Executed after a command has been read and is to be executed
preexec_functions+='preexec_update_git_vars'
# Executed after a directory change
chpwd_functions+='chpwd_update_git_vars'

# Load colors
autoload -U colors
colors

git_super_status() {
    local STATUS
    if [ -n "$__CURRENT_GIT_STATUS" ]; then
  STATUS="$ZSH_THEME_GIT_PROMPT_PREFIX$ZSH_THEME_GIT_PROMPT_BRANCH$GIT_BRANCH"
  if [ -n "$GIT_REMOTE" ]; then
      STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_REMOTE$GIT_REMOTE"
  fi
  STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_SEPARATOR"
  if [ "$GIT_STAGED" -ne "0" ]; then
      STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STAGED$GIT_STAGED"
  fi
  if [ "$GIT_CONFLICTS" -ne "0" ]; then
      STATUS="$STATUS%K{16} $ZSH_THEME_GIT_PROMPT_CONFLICTS$GIT_CONFLICTS"
  fi
  if [ "$GIT_CHANGED" -ne "0" ]; then
      STATUS="$STATUS%K{16} $ZSH_THEME_GIT_PROMPT_CHANGED$GIT_CHANGED"
  fi
  if [ "$GIT_UNTRACKED" -ne "0" ]; then
      STATUS="$STATUS%K{16} $ZSH_THEME_GIT_PROMPT_UNTRACKED"
      if [ "$GIT_UNTRACKED" -lt "10" ]; then
    STATUS="$STATUS$GIT_UNTRACKED"
      else
    STATUS="$STATUS%K{16} $ZSH_THEME_GIT_PROMPT_UNTRACKED_MANY"
      fi
  fi
  if [ "$GIT_CLEAN" -eq "1" ]; then
      STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
  STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_SUFFIX"
  echo "$STATUS"
    fi
}

local __UPDATE_GIT_PR=1 # Manage cache

# Variables used to store git status
local _GIT_STATUS
local __CURRENT_GIT_STATUS
local GIT_BRANCH
local GIT_REMOTE
local GIT_STAGED
local GIT_CONFLICTS
local GIT_CHANGED
local GIT_UNTRACKED
local GIT_CLEAN

function precmd_update_git_vars() {
  # if we update_current_git_vars every time we generate a prompt, it can be a little slow on some systems
    if [ -n "$__UPDATE_GIT_PR" ]; then
      update_current_git_vars
        unset __UPDATE_GIT_PR
    fi
}

function preexec_update_git_vars() {
    case "$2" in
        git*)
        __UPDATE_GIT_PR=1
        ;;
    esac
}

function chpwd_update_git_vars() {
     __UPDATE_GIT_PR=1
}

function update_current_git_vars() {
    unset _GIT_STATUS
    unset __CURRENT_GIT_STATUS

    local gitstatus="$__GIT_PROMPT_DIR/gitstatus.py"
    _GIT_STATUS=`python ${gitstatus}`
    __CURRENT_GIT_STATUS=("${(@f)_GIT_STATUS}")
    GIT_BRANCH=$__CURRENT_GIT_STATUS[1]
    GIT_REMOTE=$__CURRENT_GIT_STATUS[2]
    GIT_STAGED=$__CURRENT_GIT_STATUS[3]
    GIT_CONFLICTS=$__CURRENT_GIT_STATUS[4]
    GIT_CHANGED=$__CURRENT_GIT_STATUS[5]
    GIT_UNTRACKED=$__CURRENT_GIT_STATUS[6]
    GIT_CLEAN=$__CURRENT_GIT_STATUS[7]
}

function _prompt_char() {
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    echo "%{%F{blue}%}±%{%f%k%b%}"
  else
    echo ' '
  fi
}

# Default values for the appearance of the prompt. Configure at will.
ZSH_THEME_GIT_PROMPT_PREFIX=" [%{%B%F{blue}%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{%f%b%K{16}%B%F{green}%}]"
ZSH_THEME_GIT_PROMPT_SEPARATOR="%B%F{231}%K{16}|%b"
ZSH_THEME_GIT_PROMPT_BRANCH="%F{blue}"
ZSH_THEME_GIT_PROMPT_STAGED="%K{16}%F{green}●"
ZSH_THEME_GIT_PROMPT_CONFLICTS="%B%F{196}✖"
ZSH_THEME_GIT_PROMPT_CHANGED="%K{16}%F{yellow}✚"
ZSH_THEME_GIT_PROMPT_REMOTE=""
ZSH_THEME_GIT_PROMPT_UNTRACKED="%F{196}⚡"
ZSH_THEME_GIT_PROMPT_UNTRACKED_MANY="…"
#ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_CLEAN="%K{16}%F{46}✔"

# unused
#ZSH_THEME_GIT_PROMPT_DIRTY=" %{%F{red}%}*%{%f%k%b%}"

PROMPT='%{%B%F{green}%K{16}%}%n%{%B%F{blue}%}@%{%B%F{cyan}%}%m%{%B%F{green}%} %{%b%F{yellow}%K{16}%}%~%{%B%F{green}%}$(git_super_status)%E%{%f%k%b%}
$(_prompt_char) %#%{%f%k%b%} %{%f%k%b%}'

RPROMPT='%{%F{39}%}%D{%I:%M:%S}'
#RPROMPT='!%{%B%F{cyan}%}%!%{%f%k%b%}' # prints command history number
