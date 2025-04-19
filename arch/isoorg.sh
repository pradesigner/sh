#!/usr/bin/env zsh

#################################################################################################
# arch iso setup                                                                                #
#                                                                                               #
# AUTH: pradesigner                                                                             #
# VDAT: v1 - 2023-08-01                                                                         #
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
IFS=";"



########
# Main #
########
case $TYP in
    EFI)
        echo "is EFI"
        LABEL="gpt" # for gpt on EFI machines
        BOOTER="primary fat32 1MiB 260MiB"
        ESP="set 1 esp on" # esp is an alias for boot
        BOOTDIR="efi"
        FORMAT1="mkfs.fat"
        ;;
    NOEFI)
        echo "not EFI"
        LABEL="xfs" # set to 'msdos' for mbr on NOEFI machines
        BOOTER="primary xfs 1MiB 260MiB"
        #ESP="set 1 boot on"
        ESP="set 1 bios_grub on"
        BOOTDIR="boot"
        FORMAT1="mkfs.xfs"
        ;;
esac

## system clock
echo "ensure the system clock is accurate"
timedatectl set-ntp true

## setup partitions
echo "zap all partitions"
sgdisk -Z $DEV

echo "re-partition"
parted --script $DEV \
       mklabel $LABEL \
       mkpart $BOOTER \
       $ESP \
       mkpart primary linux-swap 260MiB 4GiB \
       mkpart primary xfs 4GiB 40GiB \
       mkpart primary xfs 40GiB 100%


echo "format partitions"
$FORMAT1 "$DEV"1
mkfs.xfs -f "$DEV"3
mkfs.xfs -f "$DEV"4
mkswap "$DEV"2
swapon "$DEV"2

echo "mount partitions"
mount "$DEV"3 /mnt
mkdir /mnt/$BOOTDIR /mnt/home
mount "$DEV"4 /mnt/home
mount "$DEV"1 /mnt/$BOOTDIR


## essential install
echo "install essential packages"
pacman -Syi
pacman -S --noconfirm archlinux-keyring
pacstrap /mnt base linux linux-firmware emacs iwd dhcpcd openssh grub zsh


## setup fstab
genfstab -U /mnt >> /mnt/etc/fstab

## copy over archinstall.sh
cp archins.sh /mnt

## chroot
arch-chroot /mnt



exit



#########
# Notes #
#########


