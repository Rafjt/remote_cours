# Cours de Cryptologie

## 1. Introduction

**Cryptologie** : Science de la sécurité de l'information qui se divise en deux branches :
- **Cryptographie** : Techniques pour sécuriser la communication.
- **Cryptanalyse** : Étude des méthodes pour briser les systèmes de cryptographie.

## 2. Types de Chiffrement

### 2.1. Cryptographie Symétrique
- **Principe** : Utilisation de la même clé secrète pour le chiffrement et le déchiffrement.
- **Exemples** :
  - **AES (Advanced Encryption Standard)** : Algorithme de chiffrement par blocs de 128, 192, ou 256 bits.
  - **DES (Data Encryption Standard)** : Ancien standard de 56 bits, désormais obsolète.
- **Méthodes** :
  - **Chiffrement par bloc** : Traite le message en blocs de taille fixe (ex. AES).
  - **Chiffrement par flot** : Chiffre le message bit par bit ou octet par octet (ex. RC4).

### 2.2. Cryptographie Asymétrique
- **Principe** : Utilisation d'une paire de clés :
  - **Clé publique** : Connue de tous pour le chiffrement.
  - **Clé privée** : Secrète, utilisée pour le déchiffrement.
- **Exemples** :
  - **RSA** : Basé sur la difficulté de factorisation de grands nombres premiers.
  - **ECC (Elliptic Curve Cryptography)** : Basé sur les propriétés des courbes elliptiques, offrant une sécurité équivalente avec des clés plus courtes.

## 3. Concepts de Sécurité

- **Confidentialité** : Protection du contenu des messages.
- **Intégrité** : Garantir que le message n'a pas été modifié.
- **Authentification** : Vérifier l'identité de l'expéditeur.
- **Non-répudiation** : L'expéditeur ne peut nier avoir envoyé le message.

## 4. Méthodes de Chiffrement Classiques

- **Substitution** : Remplacer les caractères du message par d'autres caractères.
  - **Exemple** :
    - **Chiffrement mono-alphabétique** : Remplacement fixe des lettres (ex. A -> X).
    - **Chiffrement de César** : Décalage fixe dans l'alphabet, souvent de 3 positions (A -> D).
- **Transposition** : Changer l'ordre des lettres sans les remplacer.
  - **Exemple** : Le mot "CRYPTO" peut être transposé en "RTOCYP".

- **Chiffrement de Vigenère** : Utilise une clé pour appliquer un décalage variable basé sur la clé.
  - **Exemple** :
    - Message clair : "HELLO"
    - Clé : "KEY"
    - Texte chiffré : Calculé par des décalages dépendants de "KEY".

## 5. Chiffrement Moderne

- **Chiffre de Vernam (One-Time Pad)** :
  - **Principe** : XOR entre le message clair et une clé aléatoire de la même longueur.
  - **Sécurité** : Inviolable si la clé est aléatoire et utilisée une seule fois.
  - **Exemple** :
    - Message clair : `01010100` (ASCII 'T')
    - Clé : `00111001`
    - Message chiffré : `01101101`
    - Déchiffrement : `01101101` XOR `00111001` = `01010100` ('T').

- **AES (Advanced Encryption Standard)** :
  - **Caractéristiques** : Basé sur le chiffrement par blocs, utilisant des clés de 128, 192 ou 256 bits.
  - **Applications** : Utilisé pour sécuriser les communications sur Internet (ex. HTTPS).

## 6. Certificats Électroniques

- **Définition** : Document numérique utilisé pour vérifier l'identité d'une entité (personne, serveur).
- **Composants** :
  - **Clé publique** de l'entité.
  - **Informations d'identification** (nom, organisation).
  - **Signature numérique** d'une autorité de certification (CA).
- **Utilisation** : Assurer l'authenticité dans les communications sécurisées (ex. SSL/TLS).

## 7. Cryptanalyse

- **Cryptanalyse classique** :
  - **Analyse fréquentielle** : Utilisée pour casser les chiffrements de substitution en étudiant la fréquence des lettres.
  - **Attaque brute-force** : Essayer toutes les clés possibles jusqu'à trouver la bonne.
- **Cryptanalyse par implémentation** :
  - **Side-channel attacks** : Exploiter des fuites physiques comme la consommation d'énergie.
  - **Erreurs de codage** : Exploitation des bugs dans l'implémentation du chiffrement.
- **Ingénierie sociale** : Exploiter la faiblesse humaine pour obtenir des informations confidentielles.

## 8. Protocoles de Sécurité

- **TLS/SSL** : Protocoles pour sécuriser les communications sur Internet via des mécanismes de cryptographie asymétrique et symétrique.
- **PGP (Pretty Good Privacy)** : Utilisé pour le chiffrement des emails, assurant la confidentialité et l'authenticité.
- **Protocole de Diffie-Hellman** : Permet l'échange sécurisé de clés sur un canal non sécurisé.

## 9. Encodage vs Chiffrement

- **Encodage** : Transformation des données dans un format standardisé, souvent réversible sans clé (ex. Base64).
- **Chiffrement** : Transformation des données pour les rendre inintelligibles sans clé spécifique.
- **Exemple** : Le mot "HELLO" peut être encodé en Base64 comme "SEVMTE8=", mais chiffré avec AES, il devient un texte illisible.

## 10. Complexité des Algorithmes

- **Exemple** : Si une opération de \(2^{30}\) prend 1 seconde, alors une opération de \(2^{88}\) prendrait \(2^{58}\) secondes, soit environ **9,14 milliards d'années**.
  - **Implication** : Les attaques par brute-force sont impraticables pour des clés suffisamment longues.

## 11. Chiffrement Recherchable (Searchable Encryption)

- **Principe** : Permet d'effectuer des recherches sur des données chiffrées sans les déchiffrer.
- **Applications** : Bases de données sécurisées, services cloud avec protection des données privées.

## 12. Exercices Pratiques

- **Exemple 1** : Décoder "IHUPL" avec le chiffrement de César (décalage de 3).
  - **Solution** : "FERMI".
- **Exemple 2** : Déchiffrer "OYB" avec la clé "LAO" utilisant le chiffre de Vigenère.

## 13. Chiffre de Vernam - Exemple Pratique
- Données ASCII :
  - **Message clair** : "E" (ASCII 69 : `1000101`)
  - **Clé** : `0000 0110`
  - **Chiffrement** : `1000101` XOR `0000 0110` = `1000011` (ASCII 67 : 'C').

## Conclusion
La cryptographie moderne repose sur des concepts de sécurité solides, incluant la confidentialité, l'intégrité, l'authentification et la non-répudiation. Bien qu'elle propose des méthodes robustes pour protéger l'information, la cryptanalyse tente de briser ces systèmes en exploitant des vulnérabilités mathématiques ou des erreurs d'implémentation.
"""