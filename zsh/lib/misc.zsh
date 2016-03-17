## smart urls
# TODO why isn't this working?
# https://github.com/zsh-users/zsh/blob/master/Functions/Zle/url-quote-magic
# https://github.com/sorin-ionescu/prezto/issues/978
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

## file rename magick
bindkey "^[m" copy-prev-shell-word

## jobs
setopt long_list_jobs

## pager
export PAGER="less"
export LESS="-R"

export LC_CTYPE=$LANG
