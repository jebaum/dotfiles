alias reload='source ~/dotfiles/zsh/aliases.zsh'

# command aliases
alias sudo='sudo -E '
alias beep='echo -en "\a"'
alias datednotes='nvim `date "+%Y-%m-%d"`.txt'
alias fontlist='fc-list -f "%{family} : %{file}\n" :spacing=100 | sort'
alias g='git'
alias gsu='git submodule foreach git checkout master && git submodule foreach git pull'
alias make='make -j4'
alias myip='curl icanhazip.com'
alias nvim='nvim -p'
alias nvimlisten='rm -f /tmp/nvim; NVIM_LISTEN_ADDRESS=/tmp/nvim nvim -p'
alias nvimapi='nvim --api-info | python2 -c "import msgpack, sys, yaml; print yaml.dump(msgpack.unpackb(sys.stdin.read()))" | less'
alias open='xdg-open'
alias rg='rg --colors "path:fg:green" --colors "path:style:bold" --colors "line:fg:magenta" --colors "match:bg:yellow" --colors "match:fg:black" --colors "match:style:nobold" --color=always '
alias paclsorphans="pacman --query --deps --unrequired"
alias pandoc='pandoc -V geometry:margin=0.5in -f markdown+hard_line_breaks'
alias pandoczenburn='pandoc -V geometry:margin=0.5in -f markdown+hard_line_breaks --highlight-style=zenburn'
alias pandocnohighlight='pandoc -V geometry:margin=0.5in -f markdown+hard_line_breaks --no-highlight'
alias pandocunicode='pandoc --latex-engine=xelatex -V geometry:margin=0.5in -f markdown+hard_line_breaks' # requires texlive-latexextra on arch
alias pyhttp='python3 -m http.server 8080'
alias redshift='redshift -l "50:8" -t "6500:5500" -b 1.0'
alias termcolors='~/dotfiles/scripts/color/colortest.pl -w -r'
alias tron='ssh sshtron.zachlatta.com'
alias vi='vim'
alias vim='vim -p'
alias xev="xev | grep -A2 --line-buffered '^KeyRelease' | sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'"
alias xprop='xprop | grep WM_CLASS && echo The first part of WM_CLASS is the instance, second part is the class'

mem() {
    ps -eo rss,pid,euser,args:100 --sort %mem | grep -v grep | grep -i $@ | awk '{printf $1/1024 "MB"; $1=""; print }'
}

pacrmorphans() {
    sudo pacman --remove --recursive $(pacman --quiet --query --deps --unrequired)
}
ytdlmp3() { youtube-dl --audio-quality 0 --audio-format mp3 -x "${1-$(xsel)}" }
ytdl() { youtube-dl "${1-$(xsel)}" }

upgrade() {
   #sudo pacman -Syu
   yay -Syu --devel --timeupdate
 }

# cp with progress
alias cpv="rsync -poghb --backup-dir=/tmp/rsync -e /dev/null --progress --"
alias rsync-copy="rsync -avz --progress -h"
alias rsync-move="rsync -avz --progress -h --remove-source-files"
alias rsync-update="rsync -avzu --progress -h"
alias rsync-synchronize="rsync -avzu --delete --progress -h"

pf() { # process filter
  if [ "$#" = "0" ] ; then
    echo "need search terms"
  else
    ps aux | grep --color=auto -i "$@"
  fi
}

torrentadd() {
    transmission-remote -a "${1-$(xsel)}"
}
torrentdaemonstart() {
    if [ "$(pidof transmission-daemon)" ]; then
        echo transmission-daemon already running 1>&2
    else
        transmission-daemon --port 9092
        echo started transmission-daemon
    fi
}
torrentdaemonstop() {
    transmission-remote --exit
    killall transmission-daemon
}
torrentinfo()        { transmission-remote -t $1 -i }
torrentlist()        { transmission-remote -l }
torrentrmfiles()     { transmission-remote -t $1 --remove-and-delete }
torrentrm()          { transmission-remote -t $1 -r }
torrentstart()       { transmission-remote -t $1 -s }
torrentstop()        { transmission-remote -t $1 -S }
torrentwatch()       { watch -n 1 transmission-remote 9092 -l }


function up() {
  LIMIT=$1
  P=$PWD
  for ((i=1; i <= LIMIT; i++))
  do
    P=$P/..
  done
  cd $P
  export MPWD=$P
}

user_commands=(
  list-units is-active status show help list-unit-files
  is-enabled list-jobs show-environment)

sudo_commands=(
  start stop reload restart try-restart isolate kill
  reset-failed enable disable reenable preset mask unmask
  link load cancel set-environment unset-environment)

for c in $user_commands; do; alias sc-$c="systemctl $c"; done
for c in $sudo_commands; do; alias sc-$c="sudo systemctl $c"; done


magnet_to_torrent() {
  [[ "$1" =~ xt=urn:btih:([^\&/]+) ]] || return 1

  hashh=${match[1]}

  if [[ "$1" =~ dn=([^\&/]+) ]];then
    filename=${match[1]}
  else
    filename=$hashh
  fi

  echo "d10:magnet-uri${#1}:${1}e" > "$filename.torrent"
}

zsh_stats() {
  fc -l 1 | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl |  head -n20
}

# sample usage: `echo -e "${white}lol${NC}"`
white='\e[1;37m'
blue='\e[1;34m'
green='\e[1;32m'
red='\e[1;31m'
purple='\e[0;35m'
yellow='\e[1;33m'
NC='\e[0m' # No Color

# MORE COLOR CODES FOR ALIASING
#Black       0;30     Dark Gray     1;30
#Blue        0;34     Light Blue    1;34
#Green       0;32     Light Green   1;32
#Cyan        0;36     Light Cyan    1;36
#Red         0;31     Light Red     1;31
#Purple      0;35     Light Purple  1;35
#Brown       0;33     Yellow        1;33
#Light Gray  0;37     White         1;37

# vim:filetype=sh
