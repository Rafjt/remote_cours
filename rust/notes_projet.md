# 🧠 Les offsets importants (FAT32)
| Champ                | Offset | Taille | Rôle                                   |
|----------------------|---------|---------|----------------------------------------|
| Bytes per sector     | 0x0B    | 2       | (souvent 512)                          |
| Sectors per cluster  | 0x0D    | 1       | Taille d’un cluster                    |
| Reserved sectors     | 0x0E    | 2       | Zone avant la FAT                      |
| Number of FATs       | 0x10    | 1       | En général 2                           |
| FAT size (FAT32)     | 0x24    | 4       | Taille d’une FAT en secteurs           |
| Root cluster         | 0x2C    | 4       | Numéro du premier cluster du répertoire racine |


💡 Avec ces valeurs tu peux calculer où se trouve n’importe quel cluster.



# 3. Trouver le début de la Data Region

Formule :

`data_start_sector = reserved_sectors + number_of_fats * fat_size`

### Exemple typique :
```bash
reserved_sectors = 32
number_of_fats = 2
fat_size = 945
→ data_start = 32 + 2 * 945 = 1922
```

### Donc le cluster #2 (le premier cluster de données) commence au secteur :

`sector_cluster_2 = data_start`


### Lecture brute du début de la zone data :

`dd if=mydisk.img bs=512 skip=1922 count=4 | hexdump -C`
