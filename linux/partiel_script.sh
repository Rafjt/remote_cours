#!/bin/bash

# création du fichier et allocation de 5G
fallocate -l 5G secure_env.img

# chiffrement avec LUKS
cryptsetup luksFormat secure_env.img

# Ouverture du volume
cryptsetup open secure_env.img secure_vol

# création du file_system via ext4
mkfs.ext4 /dev/mapper/secure_vol

# montage du volume
mkdir -p /mnt/secure_vol
mount /dev/mapper/secure_vol /mnt/secure_vol
