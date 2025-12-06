🧠 Les offsets importants (FAT32)
| Champ                | Offset | Taille | Rôle                                   |
|----------------------|---------|---------|----------------------------------------|
| Bytes per sector     | 0x0B    | 2       | (souvent 512)                          |
| Sectors per cluster  | 0x0D    | 1       | Taille d’un cluster                    |
| Reserved sectors     | 0x0E    | 2       | Zone avant la FAT                      |
| Number of FATs       | 0x10    | 1       | En général 2                           |
| FAT size (FAT32)     | 0x24    | 4       | Taille d’une FAT en secteurs           |
| Root cluster         | 0x2C    | 4       | Numéro du premier cluster du répertoire racine |


💡 Avec ces valeurs tu peux calculer où se trouve n’importe quel cluster.
