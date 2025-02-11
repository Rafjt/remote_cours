#!/bin/bash

#installer parted
pacman -Sy parted

# à définir
parted /dev/sda --script mklabel gpt
parted /dev/sda --script mkpart ESP fat32 1MiB 513MiB
parted /dev/sda --script set 1 esp on
parted /dev/sda --script mkpart LUKS ext4 513MiB 100%

# Définition du mot de passe par défaut
echo "1234Pass" | cryptsetup luksFormat --type luks1 /dev/sdX2 #<-- créer une partition réservée a EFI
echo "1234Pass" | cryptsetup open /dev/sdX2 cryptroot #<-- créer une partition pour le stockage ou un système chiffré.

# Création des volumes LVM
pvcreate /dev/mapper/cryptroot
vgcreate vg0 /dev/mapper/cryptroot
lvcreate -L 10G -n encrypted vg0   # Espace chiffré monté manuellement
lvcreate -L 15G -n virtualbox vg0  # Espace pour VirtualBox
lvcreate -L 5G -n shared vg0       # Dossier partagé père/fils
lvcreate -l 100%FREE -n root vg0   # Système principal

# dernière snapshot snap3

# Formatage des partitions
mkfs.ext4 /dev/vg0/root
mkfs.ext4 /dev/vg0/virtualbox
mkfs.ext4 /dev/vg0/shared
mkfs.ext4 /dev/vg0/encrypted


# Configuration de la partition EFI
#parted /dev/sdX mklabel gpt
#parted /dev/sdX mkpart ESP fat32 1MiB 512MiB
#parted /dev/sdX set 1 boot on
#mkfs.fat -F32 /dev/sdX1


# Montage des partitions
mount /dev/vg0/root /mnt
mkdir -p /mnt/boot
mount /dev/sdX1 /mnt/boot
mkdir -p /mnt/virtualbox
mount /dev/vg0/virtualbox /mnt/virtualbox
mkdir -p /mnt/shared
mount /dev/vg0/shared /mnt/shared

_________________


# Mise à jour des miroirs Reflector
reflector --latest 10 --sort rate --save /etc/pacman.d/mirrorlist

# Installation de la base Arch Linux
pacstrap /mnt base linux linux-firmware lvm2 vim sudo

# Génération de fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot dans le système installé
arch-chroot /mnt <<EOF

# Configuration du fuseau horaire
ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
hwclock --systohc

# Configuration de la localisation
echo "LANG=fr_FR.UTF-8" > /etc/locale.conf
echo "KEYMAP=fr" > /etc/vconsole.conf

# Configuration réseau
echo "archlinux" > /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1 localhost" >> /etc/hosts
echo "127.0.1.1 archlinux.localdomain archlinux" >> /etc/hosts

# Installation de GRUB et configuration du bootloader
pacman -S --noconfirm grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Création des utilisateurs
useradd -m -G wheel -s /bin/bash collegue
useradd -m -G collegue -s /bin/bash fils
echo "collegue:azerty123" | chpasswd
echo "fils:azerty123" | chpasswd

# Activation du sudo pour le groupe wheel
sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers

# Configuration des permissions du dossier partagé
chown collegue:fils /shared
chmod 770 /shared

# Installation des paquets essentiels
pacman -S --noconfirm xorg hyprland firefox neovim virtualbox linux-headers base-devel git htop neofetch nano

# Activation des services essentiels
systemctl enable NetworkManager

# Ajout d'un alias pour monter l'espace sécurisé
echo 'alias mount_secure="cryptsetup open /dev/sdX2 secure && mount /dev/mapper/secure /mnt/secure"' >> /home/collegue/.bashrc

EOF

# Fin du script
echo "Installation terminée. Vous pouvez maintenant redémarrer."

