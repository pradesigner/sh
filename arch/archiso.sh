#!/usr/bin/env zsh

#################################################################################################
# arch iso setup                                                                                #
#                                                                                               #
# AUTH: pradesigner                                                                             #
# VDAT: v1 - <2023-08-01 Tue>                                                                   #
# PURP: Installs the archiso                                                                    #
#                                                                                               #
# archiso.sh installs with the archiso system and basic pacstrap items for EFI|NOEFI computers. #
#                                                                                               #
# 1. Boot the remote computer using the archlinux usb|cd.                                       #
# 2. Activate wifi with iwctl (station wlan0 connect ...)                                       #
# 3. Set passwd to 'a' or whatever.                                                             #
# 4. Start sshd: systemctl start sshd                                                           #
#                                                                                               #
# Now remote computer is accessible with ssh.                                                   #
#                                                                                               #
# 5. Copy over the archiso.sh and archins.sh files ssc ~/sh/archiso/* root@archiso:             #
# 6. Login to archiso: ssn root@archiso                                                         #
#                                                                                               #
# Run zsh archiso.sh then zsh archins.sh after chroot.                                          #
#################################################################################################


########
# Help #
########
if [[ $1 != "EFI" && $1 != "NOEFI" ]]; then
    echo "use: sets up the archlinux install"
    echo "how: archiso.sh EFI|NOEFI"
    exit
fi



#############
# Variables #
#############
TYP=$1
DEV="/dev/sda"
SWAP="primary linux-swap 260MiB 6GiB"
ROOT="primary xfs 6GiB 66GiB"
HOME="primary xfs 66GiB 100%"
IFS=";"



########
# Main #
########

## EFI or NOEFI
case $TYP in
    EFI)
        BOOTER="primary fat32 1MiB 260MiB"
        ESP="set 1 esp on" # esp is an alias for boot
        ;;
    NOEFI)
        BOOTER="primary xfs 0% 1MiB"
        ESP="set 1 bios_grub on"
        ;;
esac

## system clock
echo "ensure the system clock is accurate"
timedatectl set-ntp true


## partition
sgdisk -Z $DEV                  # zap all partitions

# setup new partitions
parted $DEV --script -- \
       mklabel gpt \
       mkpart $BOOTER \
       mkpart $SWAP \
       mkpart $ROOT \
       mkpart $HOME \
       $ESP

## format and mount
mkfs.xfs -f "$DEV"3             # root needs to be the first one
mount "$DEV"3 /mnt

if [[ "$TYP" = "EFI" ]]; then   # EFI only
    mkfs.fat "$DEV"1
    mkdir /mnt/efi
    mount "$DEV"1 /mnt/efi
fi

mkfs.xfs -f "$DEV"4             # home
mkdir /mnt/home
mount "$DEV"4 /mnt/home


## refresh keyring
pacman -Sy
pacman -S --noconfirm archlinux-keyring


## essential install
pacstrap /mnt base linux linux-firmware emacs iwd dhcpcd openssh grub mkinitcpio zsh


## finish up
genfstab -U /mnt >> /mnt/etc/fstab # setup fstab
cp archins.sh /mnt              # copy over archinstall.sh
arch-chroot /mnt                # chroot



exit



#########
# Notes #
#########

## refresh keyring (per Bing)
rm -rf /var/cache/*
gpg --refresh-keys
pacman -Sy --noconfirm archlinux-keyring && pacman --noconfirm -Syyu
pacman-key --populate archlinux
sudo pacman-key --init
sudo pacman -Syu

here is my efi script:
parted $DEV --script -- \
       mklabel gpt \
       mkpart $BOOTER \
       mkpart $SWAP \
       mkpart $ROOT \
       mkpart $HOME \
       $ESP
where
DEV="/dev/sda"
BOOTER="primary fat32 1MiB 260MiB"
SWAP="primary linux-swap 260MiB 6GiB"
ROOT="primary xfs 6GiB 66GiB"
HOME="primary xfs 66GiB 100%"

how does that look?
