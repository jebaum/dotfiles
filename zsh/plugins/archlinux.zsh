 upgrade() {
   sudo pacman -Syu
   pacaur -u
 }

# Pacman - https://wiki.archlinux.org/index.php/Pacman_Tips
alias pacupg='sudo pacman -Syu'        # Synchronize with repositories before upgrading packages that are out of date on the local system.
alias pacin='sudo pacman -S'           # Install specific package(s) from the repositories
alias pacins='sudo pacman -U'          # Install specific package not from the repositories but from a file
alias pacre='sudo pacman -R'           # Remove the specified package(s), retaining its configuration(s) and required dependencies
alias pacrem='sudo pacman -Rns'        # Remove the specified package(s), its configuration(s) and unneeded dependencies
alias pacrep='pacman -Si'              # Display information about a given package in the repositories
alias pacreps='pacman -Ss'             # Search for package(s) in the repositories
alias pacloc='pacman -Qi'              # Display information about a given package in the local database
alias paclocs='pacman -Qs'             # Search for package(s) in the local database
alias pacupd='sudo pacman -Sy'     # Update and refresh the local package database against repositories
alias pacinsd='sudo pacman -S --asdeps'        # Install given package(s) as dependencies of another package
alias pacmir='sudo pacman -Syy'                # Force refresh of all package lists after updating /etc/pacman.d/mirrorlist

# https://bbs.archlinux.org/viewtopic.php?id=93683
paclist() {
  sudo pacman -Qei $(pacman -Qu|cut -d" " -f 1)|awk ' BEGIN {FS=":"}/^Name/{printf("\033[1;36m%s\033[1;37m", $2)}/^Description/{print $2}'
}

alias paclsorphans='sudo pacman -Qdt'
alias pacrmorphans='sudo pacman -Rs $(pacman -Qtdq)'

pacdisowned() {
  tmp=${TMPDIR-/tmp}/pacman-disowned-$UID-$$
  db=$tmp/db
  fs=$tmp/fs

  mkdir "$tmp"
  trap  'rm -rf "$tmp"' EXIT

  pacman -Qlq | sort -u > "$db"

  find /bin /etc /lib /sbin /usr \
      ! -name lost+found \
        \( -type d -printf '%p/\n' -o -print \) | sort > "$fs"

  comm -23 "$fs" "$db"
}

pacmanallkeys() {
  # Get all keys for developers and trusted users
  curl https://www.archlinux.org/{developers,trustedusers}/ |
  awk -F\" '(/pgp.mit.edu/) {sub(/.*search=0x/,"");print $1}' |
  xargs sudo pacman-key --recv-keys
}

pacmansignkeys() {
  for key in $*; do
    sudo pacman-key --recv-keys $key
    sudo pacman-key --lsign-key $key
    printf 'trust\n3\n' | sudo gpg --homedir /etc/pacman.d/gnupg \
      --no-permission-warning --command-fd 0 --edit-key $key
  done
}
