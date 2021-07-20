alias reload='source ~/dotfiles/zsh/aliases.zsh'

# useful for following log files:
# tail -f /var/log/pacman.log | bat --paging=never -l log
alias ls='exa --long --group-directories-first --group --header'
alias sc='systemctl'
alias beep='echo -en "\a"'
alias datednotes='nvim `date "+%Y-%m-%d"`.txt'
alias fontlist='fc-list -f "%{family} : %{file}\n" :spacing=100 | sort'
alias g='git'
alias gsu='git submodule foreach git pull --rebase'
alias make='make -j9'
alias myip='curl icanhazip.com'
alias nvim='nvim -p'
alias nvimlisten='rm -f /tmp/nvim; NVIM_LISTEN_ADDRESS=/tmp/nvim nvim -p'
alias nvimapi='nvim --api-info | python2 -c "import msgpack, sys, yaml; print yaml.dump(msgpack.unpackb(sys.stdin.read()))" | less'
alias open='xdg-open'
alias rg='rg -S --colors "path:fg:green" --colors "path:style:bold" --colors "line:fg:magenta" --colors "match:bg:yellow" --colors "match:fg:black" --colors "match:style:nobold" --color=always '
alias paclsorphans="pacman --query --deps --unrequired"
alias pandoc='pandoc -V geometry:margin=0.5in -f markdown+hard_line_breaks'
alias pandoczenburn='pandoc -V geometry:margin=0.5in -f markdown+hard_line_breaks --highlight-style=zenburn'
alias pandocnohighlight='pandoc -V geometry:margin=0.5in -f markdown+hard_line_breaks --no-highlight'
alias pandocunicode='pandoc --latex-engine=xelatex -V geometry:margin=0.5in -f markdown+hard_line_breaks' # requires texlive-latexextra on arch
alias pyhttp='python3 -m http.server 8080'
alias termcolors='~/dotfiles/scripts/color/colortest.pl -w -r'
alias tron='ssh sshtron.zachlatta.com'
alias vim='vim -p'
alias xev="xev | grep -A2 --line-buffered '^KeyRelease' | sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'"
alias xprop='xprop | grep WM_CLASS && echo The first part of WM_CLASS is the instance, second part is the class'
alias ranger='~/dev/ranger/ranger.py'

pacrmorphans() {
    sudo pacman --remove --recursive $(pacman --quiet --query --deps --unrequired)
}
ytdlmp3() { youtube-dl --format bestaudio/best --ignore-errors --output "%(title)s.%(ext)s" --extract-audio --audio-format mp3 "${1-$(xsel)}" }
ytdl() { youtube-dl "${1-$(xsel)}" }

upgrade() {
   #sudo pacman -Syu
   yay -Syu --devel --timeupdate --answerdiff None --answerclean All --answerdiff None --removemake
 }

# cp with progress
#alias scp='rsync --verbose --progress --partial'
#alias scp='/usr/bin/rsync --archive --xattrs --acls --progress --rsh="ssh"'
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
    transmission-remote 9092 -a "${1-$(xsel)}"
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
    transmission-remote 9092 --exit
    killall transmission-daemon
}
torrentinfo()        { transmission-remote 9092 -t $1 -i }
torrentlist()        { transmission-remote 9092 -l }
torrentrmfiles()     { transmission-remote 9092 -t $1 --remove-and-delete }
torrentrm()          { transmission-remote 9092 -t $1 -r }
torrentstart()       { transmission-remote 9092 -t $1 -s }
torrentstop()        { transmission-remote 9092 -t $1 -S }
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

magnet_to_torrent() {
  [[ "$1" =~ xt=urn:btih:([^\&/]+) ]] || return 1

  hashh=${match[1]}

  if [[ "$1" =~ dn=([^\&/]+) ]]; then
    filename=${match[1]}
  else
    filename=$hashh
  fi

  echo "d10:magnet-uri${#1}:${1}e" > "$filename.torrent"
}

zsh_stats() {
  fc -l 1 | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl |  head -n20
}
# vim:filetype=sh
