#!/bin/bash

# création du fichier et allocation de 5G
dd if=/dev/zero of=secure_env.img bs=1M count=5120

# chiffrement avec LUKS
cryptsetup luksFormat secure_env.img

# Ouverture du volume
cryptsetup open secure_env.img secure_vol

# création du file_system via ext4
mkfs.ext4 /dev/mapper/secure_vol

# montage du volume
mkdir -p /mnt/secure_vol
mount /dev/mapper/secure_vol /mnt/secure_vol
