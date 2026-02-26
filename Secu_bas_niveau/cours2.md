# Cours 2

### NX-BIT / Data Execution Prevention

Le nx bit est le no execute bit aussi appelé Data Execution Prevention(DEP).Il empeche d'avior un espace mémoire en lecture et execution. 

segment TEXT => RX
compléter 

C'est donc le fait de marquer des pages comme non executable. 

- Sur intel il est appelé XB-bit
- Sur MPS il est appelé Xl-bit
- Sur ARM il est appelé XN-bit

### Canary 

Ce sont des variables implantées par le compilateur dans la mémoire du programme, afin de détecter des tentatives de corruption mémoire et donc d'exploitation. Permet d'éviter qu'un attaquant ne soit pas en capacité d'overwrite l'adresse de retour notamment.

Bien qur ce comportement soit parfois par défaut il est implémanté dans le compilateur avec plusieurs flag :
fstack-protector: que pour les buffer de 8 octet 

fstack-protector-all: tout les buffer

fstack-protector-strong 
