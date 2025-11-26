# CRYPTO – COURS 2

## Comunication sécuriser

sur un canal non sécurisé :
- Attaquant passif : confidentialité 
- Attaquant actif : intégrité

## Authentification

*Unilatérale* : les pages web consultable par exemple wikipedia, youtube, w3c, etc...

*Mutuelle* : Partout où il faut s'authentifier messagerie, banque, etc...

Dans une authentification le challenge V doit être aléatoire. Elle doit être différente et non prédictible.

**DANS LE CAS DU SYMÉTRIQUE :**

Le fait de partager ne marche que dans le cas où on as une flotte sur laquelle on a un contrôle totale

**DANS LE CAS DE L'ASYMÉTRIQUE :**

On va demander un check de signature pour vérifier que notre destinataire dispose bien de clé privé avec laquelle on veut échanger.

Pour éviter une attaque MITM, on va devoir s'en référer à une **AC** **A**utorité de **C**onfiance (third party).

schéma d'arbre d'AC qui remonte de feuille à intermédiare jusqu'a root

### Protocole challenge-response :

Si la valeur v (challenge) est fixe il peut y avoir du rejeux.

## Certficat

ils disposent d'un serial number (identification) evidemment pas de la clé privé mais la clé publique. Les algo utilisées bla bla bla.

## Authentification de la personne

Facteur de connaissance (ce que je sais):
- pwd, passphrase, code PIN, etc...

Facteur de possession (ce que je possède):
- clé usb, carte a puce, pc, téléphone, etc...

Facteur inhérent (ce que je suis):
- Reconnaissance faciale, biométrie, rétine, etc...

On parle d'authentification forte si on a plein de facteurs d'authentification combiné.
