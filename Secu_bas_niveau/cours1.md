# Cours 1 
### Notes test positionnement: 
- les instruction executé dans un programme sont éxécuter par le CPU.
- Un registre CPU est : une mémoire très rapide interne au procésseur (rax,rbx,rsp,rip,etc...). 
- Le role de la ram est de stocker des programme et des donnnées en cours d'utilisation. 
- Le bus sert a transporter des données et sigaux entre composant. 
- La mémoire virtuelle permet d'abstraire l'addressage mémoire pour les processus (donc en gros le process ne voit pas les adresse physique il ne voit que les adresses virtuelle donc il n'est que sur la mémoire qu'il ne lui est que alloué si jamais on sort de ces bornes on segfault évite également que les processus ne se voit pas entre eux et donc n'écrive pas sur la mémoire des un des autres).
- La SWAP est la mémoire virtuelle sur le disque elle permet de stocker les données de tout les logiciels => les données les moins utiliser en SWAP Comme une sorte de cache (A NE PAS CRONFONDRE AVEC LE CACHE CPU).
- La stack sert a stocker des variables locales et des adresses de retour.
- Une instrution assembleur = une instruction machine. 
- MOV en assembleur est un mnémonique il sert a copier/deplacer de la données
- JPM = sauter a une addresse 
- PUSH sert a ajouter une valeur sur la stack
- IP stock le instruction pointer (l'adresse de la prochaine instruction a éxécuter)
- Le scheduler sert a répartir l'usge du CPU entre les processus
- Le mode user est un mode restreint
- Le DEP/NX permet d'empêcher l'execution de données (Les pages du segment mémoire sont marquées non executable).
- Le canary empêche une corruption de la stack (c'est une valeur placé avant le IP et si ce dernier n'est pas intègre le programme est retourner)
- L'execution ou of order permet d'optimiser l'optilmisation des ressources
- Une condition If est un embranchement
- Un appelle système permet d'accéder à des fonctionnalités du kernel
- L'isolation des rocessus garantie la séparation de l'utilisation mémoire 
  

### Notes générales : 
- rbp et rsp forment la stack frame
- On peut créer des liens entre les process en passant par des socket et des pipes
- les registres en R = 64b, E = 64b 
- Le BIOS sert a avoir root
- L'ASLR ne randomize pas le segment `.text`
- 
