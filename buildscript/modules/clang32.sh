grep -qF '[clang32]' /etc/pacman.conf || sed -i '1s|^|[clang32]\nInclude = /etc/pacman.d/mirrorlist.mingw\n|' /etc/pacman.conf
