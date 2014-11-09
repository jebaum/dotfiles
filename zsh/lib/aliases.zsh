alias aliases='vim ~/dotfiles/zsh/lib/aliases.zsh && source ~/dotfiles/zsh/lib/aliases.zsh'
alias lock='i3lock -i ~/.lockscreen.png -t -b -c 000000'

# command aliases
alias sudo='sudo -E '
alias cl='echo "!!" | xclip'
alias eclimd='~/.eclipse/org.eclipse.platform_4.4.1_1543616141_linux_gtk_x86_64/eclimd'
alias fontlist='fc-list -f "%{family} : %{file}\n" :spacing=100 | sort'
alias g='git'
alias gist='gist -c -p'
alias grep='grep --color=auto'
alias gvim='gvim -p'
alias hlerrors="sed -e 's/Exception/\x1b[36;7m&\x1b[0m/ig' -e 's/Error/\x1b[33;7m&\x1b[0m/ig' -e 's/Fault/\x1b[31;7m&\x1b[0m/ig'"
alias livestreamer='livestreamer -p mpv'
alias make='make -j4'
alias myip='curl icanhazip.com'
alias network='lsof -P -i -n'
alias nyan='nc -v nyancat.dakko.us 23' # nyan cat
alias ocaml='rlwrap -m ocaml'
alias open='xdg-open'
alias pandoc='pandoc -V geometry:margin=0.5in -f markdown+hard_line_breaks'
alias pandoczenburn='pandoc -V geometry:margin=0.5in -f markdown+hard_line_breaks --highlight-style=zenburn'
alias pandocnohighlight='pandoc -V geometry:margin=0.5in -f markdown+hard_line_breaks --no-highlight'
alias pandocunicode='pandoc --latex-engine=xelatex -V geometry:margin=0.5in -f markdown+hard_line_breaks' # requires texlive-latexextra on arch
alias pong='ping 8.8.8.8 -c 4'
alias publish='python3 -m http.server 8080'
alias 'p?'='ps aux | grep -i '
alias rcd='cd "`xclip -o`"'
alias sedtree="find . -type d |sed 's:[^-][^/]*/:--:g; s:^-: |:'"
alias tags='./.git/hooks/ctags >/dev/null'
alias termcolors='~/dotfiles/scripts/color/colortest.pl -w -r'
alias tmux='tmux -u'
alias top='htop'
alias tree='tree -C'
alias vim='vim -p'
alias vi='vim'
alias xev="xev | grep -A2 --line-buffered '^KeyRelease' | sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'"
alias x='exit'
alias ytdlmp3='youtube-dl --audio-quality 0 --audio-format mp3 -x'
alias ytdl='youtube-dl'
alias yt='youtube-viewer'

# cp with progress
alias cpv="rsync -poghb --backup-dir=/tmp/rsync -e /dev/null --progress --"
alias rsync-copy="rsync -avz --progress -h"
alias rsync-move="rsync -avz --progress -h --remove-source-files"
alias rsync-update="rsync -avzu --progress -h"
alias rsync-synchronize="rsync -avzu --delete --progress -h"

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

    if [ "$HOST" = "rig5" ]; then
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
    pirate-get --color --custom "transmission-remote 9092 -a '%s'" $1
}
torrentadd()         { transmission-remote -a "$1"}
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
torrentwatch()       { watch -n 5 transmission-remote 9092 -l }


function say() { echo mpv -really-quiet "http://translate.google.com/translate_tts?tl=en\&q=$*" | sed 's/ /+/3g' | sh 2>/dev/null; }

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

function iwhois() {
    resolver="whois.geek.nz"
    tld=`echo ${@: -1} | awk -F "." '{print $NF}'`
    whois -h ${tld}.${resolver} "$@" ;
}

WHO_COLOR="\e[0;33m"
TEXT_COLOR="\e[0;35m"
COLON_COLOR="\e[0;35m"
END_COLOR="\e[m"

function quote()
{
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


function magnet_to_torrent() {
	[[ "$1" =~ xt=urn:btih:([^\&/]+) ]] || return 1

	hashh=${match[1]}

	if [[ "$1" =~ dn=([^\&/]+) ]];then
	  filename=${match[1]}
	else
	  filename=$hashh
	fi

	echo "d10:magnet-uri${#1}:${1}e" > "$filename.torrent"
}

function zsh_stats() {
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
