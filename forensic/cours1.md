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
