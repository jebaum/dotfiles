alias aliases='vim ~/dotfiles/zsh/lib/aliases.zsh && source ~/dotfiles/zsh/lib/aliases.zsh'
alias reload='source ~/dotfiles/zsh/aliases.zsh'
alias lock='i3lock -b -c 000000'

# command aliases
alias sudo='sudo -E '
alias beep='echo -en "\a"'
alias fontlist='fc-list -f "%{family} : %{file}\n" :spacing=100 | sort'
alias g='git'
alias gsu='git submodule foreach git checkout master && git submodule foreach git pull'
alias gvim='gvim -p'
alias make='make -j4'
alias mutt="rm -f $HOME/.mutt/mail/selected; mutt"
alias myip='curl icanhazip.com'
alias nvim='nvim -p'
alias nvimlisten='rm -f /tmp/nvim; NVIM_LISTEN_ADDRESS=/tmp/nvim nvim -p'
alias nvimapi='nvim --api-info | python2 -c "import msgpack, sys, yaml; print yaml.dump(msgpack.unpackb(sys.stdin.read()))" | less'
alias nyan='nc -v nyancat.dakko.us 23' # nyan cat
alias open='xdg-open'
alias paclsorphans="pacman --query --deps --unrequired"
alias pandoc='pandoc -V geometry:margin=0.5in -f markdown+hard_line_breaks'
alias pandoczenburn='pandoc -V geometry:margin=0.5in -f markdown+hard_line_breaks --highlight-style=zenburn'
alias pandocnohighlight='pandoc -V geometry:margin=0.5in -f markdown+hard_line_breaks --no-highlight'
alias pandocunicode='pandoc --latex-engine=xelatex -V geometry:margin=0.5in -f markdown+hard_line_breaks' # requires texlive-latexextra on arch
alias pong='ping 8.8.8.8 -c 4'
alias pyhttp='python3 -m http.server 8080'
alias redshift='redshift -l "50:8" -t "6500:5500" -b 1.0'
alias tags='./.git/hooks/ctags >/dev/null'
alias termcolors='~/dotfiles/scripts/color/colortest.pl -w -r'
alias tree='tree -C'
alias tron='ssh sshtron.zachlatta.com'
alias vi='vim'
alias vim='vim -p'
alias vimtip='shuf -n 1 /home/james/Dropbox/Documents/Misc/learn/vim/vimtips.txt | cowsay -f $(ls /usr/share/cows | shuf -n 1)'
alias xev="xev | grep -A2 --line-buffered '^KeyRelease' | sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'"

pacrmorphans() {
    sudo pacman --remove --recursive $(pacman --quiet --query --deps --unrequired)
}
ytdlmp3() { youtube-dl --audio-quality 0 --audio-format mp3 -x "${1-$(xsel)}" }
ytdl() { youtube-dl "${1-$(xsel)}" }

upgrade() {
   sudo pacman -Syu
   pacaur -u
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

recordwindow() {
    recordmydesktop --windowid $(xwininfo | awk '/Window id:/ {print $4}')
}

# manually create ~/.python, get python2 and python 3 virtualenv packages
# useful to make syntastic use the correct python version, among other things
venv() {
    local activate=~/.python/$1/bin/activate
    if [ -e "$activate" ] ; then
        source "$activate"
    else
        echo "Error: Not found: $activate"
    fi
}
venv2() { venv 2 }  # run `virtualenv2 2` in ~/.python
venv3() { venv 3 }  # run `virtualenv 3` in ~/.python

venv27() { venv 27 ; }
function syn() {
    local RIG="192.168.1.100"
    local THINKPAD="192.168.1.101"

    if [ "$HOST" = "rig6" ]; then
        local CLIENT=$THINKPAD
        local SERVER=$RIG
    else
        local CLIENT=$RIG
        local SERVER=$THINKPAD
    fi

    nc -z $CLIENT 50000
    STATUS=$?
    if [ $STATUS -ne 0 ]; then
        echo $CLIENT is unavailable
        return 1
    fi

    ssh -p 50000 $CLIENT 'killall synergys; killall synergyc' &>/dev/null
    killall synergys synergyc &>/dev/null

    if [ "$1" = "kill" ]; then
        return
    fi

    synergys &>/dev/null
    ssh -p 50000 $CLIENT synergyc $SERVER &>/dev/null
}

alias transmission-remote='transmission-remote 9092'
pget() {
    torrentdaemonstart 2>/dev/null
    pirate-get --port 9092 -t "$@"
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

function quote()
{
  local WHO_COLOR="\e[0;33m"
  local TEXT_COLOR="\e[0;35m"
  local COLON_COLOR="\e[0;35m"
  local END_COLOR="\e[m"

  Q=$(curl -s --connect-timeout 2 "http://www.quotationspage.com/random.php3" | iconv -c -f ISO-8859-1 -t UTF-8 | grep -m 1 "dt ")
  TXT=$(echo "$Q" | sed -e 's/<\/dt>.*//g' -e 's/.*html//g' -e 's/^[^a-zA-Z]*//' -e 's/<\/a..*$//g')
  W=$(echo "$Q" | sed -e 's/.*\/quotes\///g' -e 's/<.*//g' -e 's/.*">//g')
  if [ "$W" -a "$TXT" ]; then
    echo "${WHO_COLOR}${W}${COLON_COLOR}: ${TEXT_COLOR}“${TXT}”${END_COLOR}"
  else
    quote
  fi
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
