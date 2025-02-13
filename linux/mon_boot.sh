#!/bin/bash

set -e  # Arrêter l'exécution en cas d'erreur

# Vérifier si l'utilisateur est root
if [ "$EUID" -ne 0 ]; then
    echo "Ce script doit être exécuté en tant que root."
    exit 1
fi

# Suppression de toute données existante sur le disque
wipefs --all --force /dev/sda

# Installer parted
pacman -Sy --noconfirm parted

# Création des partitions
parted /dev/sda --script mklabel gpt
parted /dev/sda --script mkpart ESP fat32 1MiB 513MiB
parted /dev/sda --script set 1 esp on
parted /dev/sda --script mkpart LUKS ext4 513MiB 100%

# Définition du mot de passe par défaut
echo "azerty123" | cryptsetup luksFormat --type luks1 /dev/sda2 --batch-mode
echo "azerty123" | cryptsetup open /dev/sda2 cryptroot

# Création des volumes LVM
pvcreate /dev/mapper/cryptroot
vgcreate vg0 /dev/mapper/cryptroot
lvcreate -L 10G -n encrypted vg0
lvcreate -L 15G -n virtualbox vg0
lvcreate -L 5G -n shared vg0
lvcreate -l 100%FREE -n root vg0

# Formatage des partitions
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/vg0/root
mkfs.ext4 /dev/vg0/virtualbox
mkfs.ext4 /dev/vg0/shared
mkfs.ext4 /dev/vg0/encrypted

# Montage des partitions
mount /dev/vg0/root /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot
mkdir -p /mnt/virtualbox
mount /dev/vg0/virtualbox /mnt/virtualbox
mkdir -p /mnt/shared
mount /dev/vg0/shared /mnt/shared

# Installation de la base Arch Linux
pacstrap /mnt base linux linux-firmware lvm2 vim sudo

pacstrap /mnt base linux linux-firmware nano sudo lvm2 networkmanager

# Génération du fichier fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot et configuration du système
arch-chroot /mnt /bin/bash <<EOF
set -e
ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
hwclock --systohc

sed -i 's/^HOOKS=(.*)/HOOKS=(base udev autodetect modconf block encrypt lvm2 filesystems keyboard fsck)/' /etc/mkinitcpio.conf
mkinitcpio -P

# Configuration de la langue
echo "LANG=fr_FR.UTF-8" > /etc/locale.conf
echo "KEYMAP=fr" > /etc/vconsole.conf

# Configuration du réseau
echo "archlinux" > /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1 localhost" >> /etc/hosts
echo "127.0.1.1 archlinux.localdomain archlinux" >> /etc/hosts

# Installation du bootloader
pacman -S --noconfirm grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Création des utilisateurs
useradd -m -G wheel -s /bin/bash collegue
useradd -m -G collegue -s /bin/bash fils
echo "collegue:azerty123" | chpasswd
echo "fils:azerty123" | chpasswd

# Activation de sudo pour wheel
sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers

# Configuration des permissions du dossier partagé
mkdir -p /shared
chown collegue:fils /shared
chmod 770 /shared

# Installation des paquets essentiels
pacman -S --noconfirm xorg hyprland firefox neovim virtualbox linux-headers base-devel git htop neofetch nano

# Activation des services
#systemctl enable NetworkManager

# Ajout d'un alias pour monter l'espace sécurisé
echo 'alias mount_secure="cryptsetup open /dev/sda2 secure && mount /dev/mapper/secure /mnt/secure"' >> /home/collegue/.bashrc
EOF

# Fin du script
echo "Installation terminée. Vous pouvez maintenant redémarrer."
