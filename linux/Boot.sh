#!/bin/bash

set -e  # Stopper le script en cas d'erreur

# Vérification du mode UEFI
[ -d "/sys/firmware/efi" ] || exit 1

# Partitionnement
wipefs --all --force /dev/sda
parted /dev/sda --script mklabel gpt
parted /dev/sda --script mkpart ESP fat32 1MiB 513MiB
parted /dev/sda --script set 1 esp on
parted /dev/sda --script mkpart LUKS ext4 513MiB 100%

# Chiffrement du disque
echo "azerty123" | cryptsetup luksFormat --type luks1 /dev/sda2
echo "azerty123" | cryptsetup open /dev/sda2 cryptroot

# Création des volumes LVM
pvcreate /dev/mapper/cryptroot
vgcreate vg0 /dev/mapper/cryptroot
lvcreate -L 10G -n crypt_volume vg0
lvcreate -L 20G -n virtualbox vg0
lvcreate -L 5G -n shared vg0
lvcreate -L 2G -n swap vg0
lvcreate -l 100%FREE -n root vg0

# Formatage et montage
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/vg0/root
mkfs.ext4 /dev/vg0/virtualbox
mkfs.ext4 /dev/vg0/shared
mkswap /dev/vg0/swap

mount /dev/vg0/root /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot
mkdir -p /mnt/shared
mount /dev/vg0/shared /mnt/shared
swapon /dev/vg0/swap

# Génération de fstab
mkdir -p /mnt/etc
genfstab -U /mnt >> /mnt/etc/fstab

# Installation de base
pacstrap /mnt base linux linux-firmware nano sudo lvm2 networkmanager

# Configuration système
arch-chroot /mnt <<EOF
ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
hwclock --systohc
echo "LANG=fr_FR.UTF-8" > /etc/locale.conf
echo "fr_FR.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "archlinux" > /etc/hostname

echo "KEYMAP=fr" > /etc/vconsole.conf

localectl set-x11-keymap fr

# Initramfs
sed -i 's/^HOOKS=(.*/HOOKS=(base udev autodetect modconf block encrypt lvm2 filesystems keyboard fsck)/' /etc/mkinitcpio.conf
mkinitcpio -P

# Installation de GRUB
pacman -Sy --noconfirm grub efibootmgr
sed -i 's|^GRUB_CMDLINE_LINUX=.*|GRUB_CMDLINE_LINUX="cryptdevice=/dev/sda2:cryptroot root=/dev/mapper/vg0-root"|' /etc/default/grub
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB --recheck
grub-mkconfig -o /boot/grub/grub.cfg

# Activation du réseau
systemctl enable NetworkManager

# Création des utilisateurs
useradd -m -G wheel -s /bin/bash user
echo "user:azerty123" | chpasswd
useradd -m -G users -s /bin/bash fils
echo "fils:azerty123" | chpasswd

echo "%wheel ALL=(ALL:ALL) ALL" | EDITOR='tee -a' visudo    

# Installation des logiciels
pacman -Sy --noconfirm vim firefox virtualbox base-devel network-manager-applet

# Configuration du dossier partagé
rm -f /home/user/shared /home/fils/shared
ln -s /shared /home/user/shared
ln -s /shared /home/fils/shared
chown -R user:fils /shared
chmod 770 /shared

# Configuration de Hyprland
pacman -Sy --noconfirm hyprland waybar alacritty
mkdir -p /home/user/.config/hypr
cat <<EOT > /home/user/.config/hypr/hyprland.conf
monitor=,preferred,auto,auto
general {
    gaps_in=5
    gaps_out=10
    border_size=2
    col.active_border=0xff61afef
}
input {
    kb_layout=fr
}
EOT
chown -R user:user /home/user/.config/hypr

EOF
