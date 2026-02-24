# Cours 1 
### Notes test positionnement: 
- les instruction executé dans un programme sont éxécuter par le CPU.
- Un registre CPU est : une mémoire très rapide interne au procésseur (rax,rbx,rsp,rip,etc...). 
- Le role de la ram est de stocker des programme et des donnnées en cours d'utilisation. 
- Le bus sert a transporter des données et sigaux entre composant. 
- La mémoire virtuelle permet d'abstraire l'addressage mémoire pour les processus (donc en gros le process ne voit pas les adresse physique il ne voit que les adresses virtuelle donc il n'est que sur la mémoire qu'il ne lui est que alloué si jamais on sort de ces bornes on segfault évite également que les processus ne se voit pas entre eux et donc n'écrive pas sur la mémoire des un des autres).
- La swap 

### Notes générales : 
- rbp et rsp forment la stack frame
- On peut créer des liens entre les process en passant par des socket et des pipes
