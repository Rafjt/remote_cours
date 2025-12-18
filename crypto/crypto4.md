# crypto 4

## Rappelle AC

L'authorité sert a éviter que quelqu'un fournisse sa clé publique en s'interposant.

L'ac root signe les certificats fils.

et les certificats fils signe les certificats feuille.

Ils ne signent que la partie publique.

On verifie :
- verify(pub(ac1), message, signature) => avec message qui est le contenue du certificats 
- et on remonte jusqu’à l'AC root c'est ce que l'on appelle une chaine de certification

C'est l'entreprise a l'origine du client (exemple firefox) qui décide quel clé punlique d'AC root choisir. 

# Hashage

- Le sel évite les rainbow table attacks. parce que l'attaquant va devoir recalculer toute sa table pour chaque utilisateur. 

# MDP 

### Pour renforcer

- alphabet 
- longeur
- nombre de tentative 
- politique

l'entropie d'un mot de asse n'est pas égale à celle d'une clé parce qu'ils sont créer par des humains et pas des générateur d'aléa.

Authentification robuste se fait via un protocole challenge/responses.

# Diffie Hellman

l'ajout du modulo P permet d'éviter de pouvoir inverser X via log2() pour retrouver x

Si on a un Diffie Hellman sans module on peut l'attaquer facilement parce qu'on est dans l'ensemble des réels.

sans signature on peut faire du MAN IN THE MIDDLE

il faut en amont vérifier l’authenticité de la clé de celui avec qui on échange

l'agencement de chaque brique lors d'une communication doit être dans un ordre logique et robuste parce que sinon ça nique tout :

exemple : faire diffie hellman avant l'authent mène à ce que charlie fasse un MITM 

Tout ce qui est fait maison c'est pas bon, il faut utiliser ce qui à été mis a disposition. 

encapsulation = kem = échange de clé asymétrique

### Le post quantique ne pourra casse que du :

- KEM (échange de clé, ou KEM)
- signature

### dans notre cas RSA-OAEP ou RSA-PSS et Diffie Hellman

la diff entre le KEM et l'echange de clé :
- Le kem: seulement un des user génère la clé 
- L'échange de clé: les 2 génère des clé 

**La clé K fait a minima 2048 bits.**

Lors des étapes de communication

### Au moment de la phase de chiffrement authenifié/intègre :

- Pour choisir la fonction de hashage on regarde le nombre de bits de clé additionné du chiffrement et de l'intégrité

- AES-256-CBC et AES-256-EMAC

on devras prendre quelque chose comme :
- SHA2-512 => 256 + 256

Au bout d'un moment on perd de l'entropie a force de dérivé les clés de session, donc pour palier à se problème on fait un rafraîchissement de clé en re faisant un diffie hellman. 
