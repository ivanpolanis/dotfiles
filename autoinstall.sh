#!/bin/sh

# Inspired by Ramiro Cabral repository: https://github.com/ramirocabral/dotfiles

### VARIABLES ###

aurhelper="paru"

### FUNCTIONS ###

error() {
  #print error and exit with failure
  echo -e "ERROR : $1"
  exit 1
}

usercheck() {
  #checks username
  echo -e "Enter usename:"
  read name
  id "$name" > /dev/null 2> /dev/null || error "Invalid username!"
  mkdir -p "/home/$name/.local/src"
  export homedir="/home/$name"
  export repodir="/home/$name/.local/src"
}

welcome_msj() {
  #confirmation before installation
  echo "##### Welcome to my dotfiles install script! #####
##### Are you running this as the root user and have an internet connection?(y/n):"
  read option
  [[ $option == 'y' ]] || error "The user exited"
}

install_aur() {
  sudo -u "$name" mkdir -p "$repodir/$1" #create directory
  sudo -u "$name" git -C "$repodir" clone --depth 1 --no-tags -q "https://aur.archlinux.org/$1.git" "$repodir/$1"
  cd "$repodir/$1" || return 1
  sudo -u "$name" makepkg --noconfirm -si "$repodir/$1" > /dev/null 2>&1 || return 1
}

installpkg() {
  #install packages wihtout confirming and avoid updating already installed packages
  pacman --noconfirm --needed -S "$1" > /dev/null 2>&1 || echo -e "Error installing $1 (PACMAN)"
}

aurinstall() {
  echo "$aurinstalled" | grep -q "^$1$" && return 1
  sudo -u "$name" $aurhelper -S --noconfirm "$1" > /dev/null 2>&1 || echo "Failed installing $1 (AUR)"
}

gitinstall() {
  #just to install p10k, no need to use make
  progname="${1##*/}"
  echo "$gitinstalled" | grep -q "^$progname$" && return 1
  progname="${progname%.git}"
  dir="$repodir/$progname"
  sudo -u "$name" git -C "$repodir" clone --depth 1 --single-branch \
    --no-tags -q "$1" "$dir" \
    || {
      cd "$dir" || echo "Failed installing $1 (GIT)"
      sudo -u "$name" git pull --force origin master
    }
  cd "$dir" || return 1
}

pipinstall() {
  #if pip is not already installed, it does
  [ -x "$(command -v "pip")" ] || installpkg python-pip > /dev/null 2>&1
  echo "$pipinstalled" | grep -q "^$1$" && return 1
  pip install --break-system-packages $1 > /dev/null 2>&1 || echo "Failed installing $1 (PIP)"
}

installationloop() {
  progsfile="$homedir/progs.csv"
  #using a temp file to prevent editing the original programs file
  ([ -f "$progsfile" ] && sed '/^#/d' "$progsfile" > /tmp/progs.csv) \
    || error "Programs file not found"
  aurinstalled="$(pacman -Qqm)"
  gitinstalled="$(ls "$repodir")"
  pipinstalled="$(pip list | awk '{print $1}' | tail -n +3)"
  tmpfile="/tmp/progs.csv"
  while IFS=, read -r tag program; do
    echo "Installing $program"
    case "$tag" in
      "p") installpkg "$program" ;;
      "g") gitinstall "$program" ;;
      "a") aurinstall "$program" ;;
      "i") pipinstall "$program" ;;
    esac
  done < "$tmpfile"
}

update_grub() {
  echo "Do you want to update grub? (y/n)"
  read option
  [[ $option != 'y' ]] && return 0
  [[ -d /tmp ]] || mkdir /tmp
  git clone https://github.com/vinceliuice/grub2-themes.git /tmp/grub2-themes && cd /tmp/grub2-themes
  sudo ./install.sh -t vimix
}

### SCRIPT ###

welcome_msj

usercheck

echo "##### Installing all dependencies #####"

for x in sudo zsh base-devel ca-certificates python-pip; do
  installpkg "$x"
done

[ -f /etc/sudoers.pacnew ] && cp /etc/sudoers.pacnew /etc/sudoers # Just in case

# Allow user to run sudo without password. Since AUR programs must be installed
# in a fakeroot environment, this is required for all builds with AUR.

trap 'rm -f /etc/sudoers.d/larbs-temp' HUP INT QUIT TERM PWR EXIT # delete file if user exits
echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/larbs-temp # allow wheel users(everyone) to run sudo without password

# Install aur helper manually
echo "##### Installing AUR Helper #####"
install_aur "${aurhelper}" || error "Failed to install AUR helper"

# Main instalattion loop

installationloop

# Make zsh the default shell for the user.
chsh -s /bin/zsh "$name" > /dev/null 2>&1
sudo -u "$name" mkdir -p "/home/$name/.cache/zsh/"

#enable lightdm service
systemctl enable lightdm

update_grub

echo -e "DONE! Now reboot your computer"
