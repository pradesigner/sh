#!/usr/bin/env zsh

########################################################################
# arch install                                                         #
#                                                                      #
# AUTH: pradesigner                                                    #
# VDAT: v1 - <2023-08-01 Tue>                                          #
# PURP: Software installer                                             #
#                                                                      #
# archins.sh sets up software to a newly installed system based on the #
# category chosen. It is copied to and run from / after we arch-chroot #
# in and requires hostname, efi|noefi, category.                       #
########################################################################


########
# Help #
########
if [[ $1 == '-h' ]]; then
    echo "use: sets up software for new install"
    echo "how: archins.sh hostname EFI|NOEFI MUSIC|GNOME|SERVER|UTILS|NOX"
    exit
fi



#############
# Variables #
#############
# parameters filled check
if [[ -z $1 || -z $2 || -z $3 ]]; then
    echo "usage: archins.sh hostname EFI|NOEFI MUSIC|GNOME|SERVER|UTILS|NOX"
    exit
fi

HOSTNAME=$1
INTERFACE=$2
SOFTWARE=$3

ROOT=et
PRAD=tu


#############
# Functions #
#############



########
# Main #
########
echo "Setting timezone"
ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
hwclock --systohc

echo "Setting locale"
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo "Setting hostname"
echo $HOSTNAME > /etc/hostname
echo "127.0.0.1 localhost\n:: localhost\n127.0.0.1 $1" > /etc/hosts

echo "Enabling services"
systemctl enable dhcpcd
systemctl enable iwd
systemctl enable systemd-resolved
systemctl enable sshd

# old bootloader section moved to bottom -> solves double grub install

echo "Set users"
# set root items
echo -e "$ROOT\n$ROOT" | passwd root
usermod -s /bin/zsh root

# set the pradmin items
useradd -mU -G wheel -u 1000 pradmin
echo -e "$PRAD\n$PRAD" | passwd pradmin
usermod -s /bin/zsh pradmin

echo "Set emacs as editor"
echo "EDITOR=/usr/bin/emacs -nw" >> /etc/environment


echo "Installing software"
pacman -S archlinux-keyring --noconfirm # solved corrupt signature issue
pacman -S --noconfirm sudo rsync base-devel git fzf aspell amd-ucode intel-ucode zsh-autosuggestions zsh-syntax-highlighting xorg-xkill


case $SOFTWARE in
    NOX)                        # figure out what a nox setup should be !!!
        echo "not loading anything right now"
        ;;
    SERVER)                     # complete
        pacman -S postfix dovecot lighttpd
        ;;
    UTILS)                      # build this up appropriately over use !!!
        pacman -S xorg xorg-xinit gnome-terminal alsa-utils pipewire pipewire-alsa  pipewire-jack wireplumber vivaldi vivaldi-ffmpeg-codecs mpv cups
        ;;
    GNOME)                      # complete when we want gnome
        pacman -S --noconfirm smplayer gnome gnome-extra vivaldi vivaldi-ffmpeg-codecs mpv hplip cups
        systemctl enable gdm
        ;;
    MUSIC)                      # complete
        pacman -S --noconfirm xorg xorg-xinit gnome-terminal rosegarden fluidsynth timidity soundfont-fluid lilypond lmms qtractor frescobaldi audacity sonic-visualiser alsa-utils pipewire pipewire-alsa  pipewire-jack wireplumber vivaldi mpv hplip cups linux-rt
        # start services
        su pradmin
        systemctl --user enable emacs.service
        systemctl --user enable timidity.service
        systemctl --user enable pipewire.service
        systemctl --user enable wireplumber.service
        ;;
esac


echo "Setting bootloader"
case $INTERFACE in
    EFI)
        # setup bootloader for efi
        pacman -S efibootmgr --noconfirm
        grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
        sed -i 's/quiet\"/quiet splash\"/' /etc/default/grub
        grub-mkconfig -o /boot/grub/grub.cfg
        ;;
    NOEFI)
        # setup bootloader for noefi
        grub-install --target=i386-pc /dev/sda --bootloader-id=GRUB
        sed -i 's/quiet\"/quiet splash\"/' /etc/default/grub
        grub-mkconfig -o /boot/grub/grub.cfg
        ;;
esac

mkinitcpio -P

rm /archins.sh                  # remove the software install script

echo "all done!"
echo
echo "appropriately install paru manually, then use it to install bat, fd, leftwm, paruz, ripgrep"
echo "then transfer the configs from .config for leftwm, pipewire, etc"
echo "also transfer .xinitrc .Xmodmap .emacs.d .zsh* ~/bin ~/sh/ and anything else needed for this machine"



exit



#########
# Notes #
#########

# echo "appropriately install paru manually, then use it to install alacritty, bat, broot, fd, leftwm, paruz, ripgrep"

