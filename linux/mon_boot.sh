echo "1234Pass" | cryptsetup luksFormat --type luks1 /dev/sdX2
echo "1234Pass" | cryptsetup open /dev/sdX2 cryptroot

pvcreate /dev/mapper/cryptroot
vgcreate vg0 /dev/mapper/cryptroot
lvcreate -L 10G -n encrypted vg0   
lvcreate -L 15G -n virtualbox vg0  
lvcreate -L 5G -n shared vg0       
lvcreate -l 100%FREE -n root vg0   

mkfs.ext4 /dev/vg0/root
mkfs.ext4 /dev/vg0/virtualbox
mkfs.ext4 /dev/vg0/shared
mkfs.ext4 /dev/vg0/encrypted
mkfs.fat -F32 /dev/sdX1

mount /dev/vg0/root /mnt
mkdir -p /mnt/boot
mount /dev/sdX1 /mnt/boot
mkdir -p /mnt/mnt/virtualbox
mount /dev/vg0/virtualbox /mnt/mnt/virtualbox
mkdir -p /mnt/mnt/shared
mount /dev/vg0/shared /mnt/mnt/shared

reflector --latest 10 --sort rate --save /etc/pacman.d/mirrorlist

pacstrap /mnt base linux linux-firmware lvm2 vim sudo

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt

ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
hwclock --systohc
echo "LANG=fr_FR.UTF-8" > /etc/locale.conf
echo "KEYMAP=fr" > /etc/vconsole.conf


echo "archlinux" > /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1 localhost" >> /etc/hosts
echo "127.0.1.1 archlinux.localdomain archlinux" >> /etc/hosts

pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

useradd -m -G wheel -s /bin/bash collegue
useradd -m -G pere -s /bin/bash fils
echo "pere:azerty123" | chpasswd
echo "fils:azerty123" | chpasswd

sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers

chown pere:fils /mnt/mnt/shared
chmod 770 /mnt/mnt/shared

pacman -S --noconfirm xorg hyprland firefox neovim virtualbox linux-headers
systemctl enable NetworkManager

exit

