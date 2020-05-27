# altered version of 'blinks' theme from oh-my-zsh
setopt prompt_subst
autoload -U colors && colors # Enable colors in prompt

function _prompt_char() {
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    echo " %{%F{201}%}❯%{%f%k%b%} "
  else
    echo ' ❯%{%f%k%b%} '
  fi
}

GIT_PROMPT_PREFIX="%K{16}%{$fg[green]%}[%{$reset_color%}%K{16}"
GIT_PROMPT_SUFFIX="%K{16}%{$fg[green]%}]%{$reset_color%}%K{16}"
GIT_PROMPT_MERGING="%K{16}%{$fg_bold[magenta]%}⚡︎%{$reset_color%}%K{16}"
GIT_PROMPT_UNTRACKED="%K{16}%{$fg_bold[red]%}●%{$reset_color%}%K{16}"
GIT_PROMPT_MODIFIED="%K{16}%{$fg_bold[yellow]%}●%{$reset_color%}%K{16}"
GIT_PROMPT_STAGED="%K{16}%{$fg_bold[green]%}●%{$reset_color%}%K{16}"

# Show Git branch/tag, or hash if on detached head
parse_git_branch() {
  (git symbolic-ref HEAD || git rev-parse --short HEAD) 2> /dev/null
}

# Show different symbols as appropriate for various Git repository states
parse_git_state() {
  local GIT_STATE=""  # Compose this value via multiple conditional appends.

  local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
  if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MERGING
  fi

  if ! git diff --cached --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_STAGED
  fi

  if ! git diff --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MODIFIED
  fi

  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_UNTRACKED
  fi

  if [[ -n $GIT_STATE ]]; then
    echo "%{$fg_bold[white]%}%K{16} | $GIT_STATE"
  fi
}

# If inside a Git repository, print its branch and state
git_prompt_string() { # TODO this seems "better" than how prezto/steeef does it
                      # ctrl + / and ctrl + alt + / and other keybinds update the prompt
                      # but, it's definitely slower. hold enter.
  local git_where="$(parse_git_branch)"
  [ -n "$git_where" ] && echo " $GIT_PROMPT_PREFIX%{$fg[magenta]%}%K{16}${git_where#(refs/heads/|tags/)}$(parse_git_state)$GIT_PROMPT_SUFFIX"
}

# sexy prompt chars: ❯ » ±
PROMPT='%{%B%F{green}%K{16}%}%n%{%B%F{blue}%}@%{%B%F{cyan}%}%m%{%B%F{green}%} %{%b%F{yellow}%K{16}%}%~$(git_prompt_string)%E%{%f%k%b%}
$(_prompt_char)'

# RPROMPT='%{%F{39}%}%D{%I:%M:%S}'

# http://paulgoscicki.com/archives/2012/09/vi-mode-indicator-in-zsh-prompt/
vim_ins_mode="%{$fg[cyan]%}[INS]%{$reset_color%}%(?..[%?])"
vim_cmd_mode="%{$fg[magenta]%}[CMD]%{$reset_color%}%(?..[%?])"
vim_mode=$vim_ins_mode

function zle-keymap-select {
  vim_mode="${${KEYMAP/vicmd/${vim_cmd_mode}}/(main|viins)/${vim_ins_mode}}"
  zle reset-prompt
}
zle -N zle-keymap-select

function zle-line-finish {
  vim_mode=$vim_ins_mode
}
zle -N zle-line-finish

#function TRAPINT() {
#  vim_mode=$vim_ins_mode
#  # zle && zle reset-prompt
#  zle && zle kill-buffer
#  zle && zle accept-line
#  return $(( 128 + $1 ))
#}
# RPROMPT='%F{37}%D{%H}%F{127}%D{%M}%F{142}%D{%S} ${vim_mode}'
RPROMPT='%F{44}%D{%H}%F{164}%D{%M}%F{184}%D{%S} ${vim_mode}'
