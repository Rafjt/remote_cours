
# CRYPTO COURS 1

une construction c'est :

primitive + mode opératoire (intégrité=mac, confidentialité=CBC,GCM)

### Mode opératoire 
- Intégrité :
    - HMAC :
        - repose sur un Hachage (SHA2,SHA3,etc...)
    - CBC-MAC :
        - repose sur une primitive de chiffrement par bloc (AES-128, DES, TRIPLE-DES)
        - il a pour hypothèse de sécurité que la brique sous jacente sois robuste, et que la taille de message sois fixe.
    - EMAC :
        - CBC-MAC en surchargé.

- Chiffrement :
    - CBC
    - ECB

*RSA est une primitive de chiffrement asymétrique*

Une primitive de chiffrement par bloc est une permutation pseudo-aléatoire. Sa taille d'entrée et de sortie sont égale.

cryptologie = cryptographie et cryptanalyse

cryptographie symétrique : plus rapide, plus efficace, pas de partage de clé et ne garantie pas la non-répusiation

cryptographie asymétrique : lent, pas efficace, que pour les petites données mais il y a du partage de clé non répudiation du a la signature. 

Les ordis quantiques vont juste cassée l'asymétrique. On a pas d'attaque pour la cryptographie symétrique.

Dans la stégano le secret c'est le protocole. 

### les paramètres de sécurité :

- taille de clé 
- taille de bloc 
- taille d'emprunte 
- ? 

MAC : contrefaçon universelle/existentielle
Signature : contrefaçon universelle/existentielle

#### Résistance à la pré-image : retrouver m tel que H(m) = h

#### Résistance à la seconde pré-image : retrouver un m2 via un m1 tel que H(m1) = h H(m2) = h

#### Résistance à la collision : retrouver un m1 et m2 tel que H(m1) = h et H(m2) = h


CONTROLE DUR PROCHAINS COURS

