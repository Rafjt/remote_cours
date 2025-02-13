#!/bin/bash

# Installer parted
pacman -Sy parted

# À définir
parted /dev/sda --script mklabel gpt
parted /dev/sda --script mkpart ESP fat32 1MiB 513MiB
parted /dev/sda --script set 1 esp on
parted /dev/sda --script mkpart LUKS ext4 513MiB 100%

# Définition du mot de passe par défaut
echo "azerty123" | cryptsetup luksFormat --type luks1 /dev/sda2
echo "azerty123" | cryptsetup open /dev/sda2 cryptroot

# Création des volumes LVM
pvcreate /dev/mapper/cryptroot
vgcreate vg0 /dev/mapper/cryptroot
lvcreate -L 10G -n encrypted vg0   # Espace chiffré monté manuellement
lvcreate -L 15G -n virtualbox vg0  # Espace pour VirtualBox
lvcreate -L 5G -n shared vg0       # Dossier partagé père/fils
lvcreate -l 100%FREE -n root vg0   # Système principal

# Dernière snapshot snap3

# Formatage des partitions
ARCH=$(uname -m)  # Récupération de l'architecture

if [[ "$ARCH" == "x86_64" ]]; then
    mkfs.fat -F32 /dev/sda1  # Exécuté uniquement si l'architecture est AMD64 (x86_64)
fi

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
mount /dev/sda1 /mnt/boot
mkdir -p /mnt/virtualbox
mount /dev/vg0/virtualbox /mnt/virtualbox
mkdir -p /mnt/shared
mount /dev/vg0/shared /mnt/shared

# Mise à jour des miroirs Reflector
#reflector --latest 10 --sort rate --save /etc/pacman.d/mirrorlist

# Installation de la base Arch Linux
pacstrap /mnt base linux linux-firmware lvm2 vim sudo

# Génération de fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot dans le système installé
arch-chroot /mnt 

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

# snapshot 7

_____

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







#!/bin/bash

set -e  # Stopper le script en cas d'erreur

# Vérification du mode UEFI
[ -d "/sys/firmware/efi" ] || exit 1

# Demande de confirmation avant d'effacer le disque
read -p "Toutes les données sur /dev/sda seront effacées ! Continuer ? (o/N) " confirm
[[ "$confirm" == "o" ]] || exit 1

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
EOT
chown -R user:user /home/user/.config/hypr

EOF
