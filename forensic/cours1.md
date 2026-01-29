# Forensique
## Cours 1

L'objectif est d'extraire des élément constituant des preuves à présenter devant un tribunal. Il faut pouvoir garantir l'intégrité de ces éléments. 

Tout doit être documenté. 

Récupérer des infos pertinentes les mettres dans un rapport et les fournirs a l’autorité qui nous a mandaté. 

Le cours va se concentrer sur a partie Digital Forensique :
- Live (investiguer en live sur une machine, très rare dans le judiciaire. N'est pas en adéquation avec le fait de garantir l'intégrité des élément. Si jamais on veux investiguer la RAM ça peut être utiliser par exemple).
- Network (Réseau)
- Database 
- Computer (ordi, fs, OS, appli/logiciels, etc...)
- Mobile (On va très peu le voir, ça se concentre en gros sur les téléphones.)

différentes étapes :

- Identification, en 2 temps: 
    - identification du matériel à saisir/analyser 
    - Identification du type de donées contenues

- Utile notamment lors des perquisitions.

- L'objectif est de saisir tous les éléments pouvant interesser l’enquête, ce qu'un novice n'est pas forcément capable de faire.

...

**Le slack space** est l'espace entre la fin d'un fichier et sont dernier cluster, étant donné que un fichier est obligatoirement lié a un ou plusieurs cluser complet si jamais il n'y que 3000 octet sur un cluster de 4096 il prendras quand même les 4096 complets.

Registres :

Une base de registre c'est une sorte de db qui regroupe des infos sur la machine et sont contenue.

On peut y retrouver: 
- les programmes lancés au démarrage
- Médias USB 
- Dossiers consulter 
- Infos sur la machine
- Info sur les user
- Info sur la conf système

Les registres sont organiser en **HIVES**

Ce qui introduit le concept de HKEY :
- USERS
- CURRENT_USER
- LOCAL_MACHINE
- CURRRENT_CONFIG 
> compléter avec des explication 

Pour consulter les bases de registre on utilise ***RegEdit***
Il y a aussi ***RegReaper***. 

Les shadow-copy = des snapshot sur windows .
elles sont dans système information.

#### Les shellbags :

Ils servent à stocker les préférences d'affichaage d'un fichier (cela inclut les dossier réseau et les médias amovibles). 
N'existe que pour les fichiers qui ont été consulter au moins une fois par un user. 
Les shellbags sont stockés dans des clefs de registres. 
Permet de notamment récuperer des timestamp lié au fichier en question. 
Permet de voir si les fichiers ont exister on été ouver supprimer etc...

#### Le prefetch :

Il monitor les 10 première secondes du lancement d'un programme afin de déterminer quels sont les fichier et quelles sont les ressources mémoires nécéssaire. 

Ducoup on peu savoir si le user lance tor, eraser tout ça...
Il existe un chemin `.pf` pour chaque **programme/executable**  et si il est en doublon c'est que le programme l'est aussi. 

certains executable système génèrent un hash c'est pourquoi il y a plusieurs `.pf`.

Un prefetch est générer à la première execution du programme. Ce qui veut dire que la date de création du prefetch est la date de première execution du programme. SAUF dans le cas ou l'utilisateur aurait supprimer le fichier auquel cas la date de création est biaiser. 

#### Memoire SWAP :

extension de la mémoire vive, permettant de mettre en cache des données sur le disque

C'est utiliser quand la RAM est trop petite pour stocker les données de tout les logiciels => les données les moins utiliser seront basculer en SWAP 
Comme une sorte de `cache`.

2 types de fichiers :
- swapfile.sys: introduit sur windows 8 et encore used sur 10 
- pagefile.sys: plus grand et contient de la donnée interessante contrairement a la RAM ce ddernier n'est pas supprimer à l'extinction de la machine. 

Ils se trouvent tout deux à la racine de la partition principale. 

En fonctionnannt en mode file carving on récupère tous les fichiers présents en RAM :
- Pas de problème de fragmentation ou d’intégrité 

On peut également faire de la recherche de mots clé :
- Faite par autopsy.

On retrouves plein de données de navigation (des miniatures -> creuser ce que c'est). 

#### Fichier d'hibernation :
Fichier `hiberfile.sys`.

Copie de la mémoire RAM, c'est un artefact primordiale lors d'investigations, sa taille dépendra de la taille de RAM 8Go de RAM = fichier de 8Go

A la base c'est pour stocker tout ce qui était ouvert avant de mettre notre pc en veille prolongée. C'est pour ça quand re ouvrant le pc on retrouve l'état dans lequel on l'a coupé.

#### suppression de données :

La corbeille est un dossier. Il en existe une par user. Tout ce qui est dedans va être très facilement récuperable. 
Sou windows XP il existait un fichier info2
Sous vista on a :
`$R_<chaine aléatoire>`: contenu du fichier 
`$I_<chaine aléatoire>`: métadonnées du fichier

on peut les récupérer via l'outil refuti

sur fat32 un fichier est marqué comme supprimer en modifiant le premier octet de son nom. 
L'espaceoccupé est marqué comme allouable tant que ce dernier n'est pas ré ecrit il est accessible. 

Sur autopsy on voit la différence :
"Filesystem"
"All"

Pour rendre impossible le "file carving" on fait du `wiping` c'est a dire re écrire sur la données. 

plusieurs outil de wiping : 
Shred sur linux 
Secure-delete:
- Srm: fichier secure // rajouter les infos manquante 
- Sswap: MEM SWAP // rajouter les infos manquante 
- Sfill: // rajouter les infos manquante 
- Smem: => RAM // rajouter les infos manquante 





#### Cassage de mots de passe:




TIPS POUR LE PROJET : FAIRE DU FILE CARVING EN SORTANT JSP QUOI ET LE METRE DANS FOREMOST. 


