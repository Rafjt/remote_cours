# Cisco secu 

### MAC
Les switch ont un comportement deviant sur leurs plus vieille version ou bas de gamme une fois leurs table mac rempli elle est censé s'écrasé et re ecrire depuis le debut mais avec ce comportement il passe juste en mode HUB et par conséquent broadcast tout vers tout le monde. 

### ARP
La requête de demande d'ip se fait en broadcast et la réponse ce fait en unicast. 

L'ARP spoofing permet de faire une ARP reply à la place de quelqu'un d'autre pour permettre de d'intercepter tout ces paquets. 

Pour s'en proteger il faut activer un système de détéction de spoofing qui s'appelle la DAI. (Sur du Cisco)

### Port security 
Dans le cas ou on détecte plusieurs mac qui viennent de la même interface sur le switch et bien on bloque (pendant une certaine durée). Cela doit être activer à part si on a connecter un switch à l'interface en question.

### DHCP
L'attaque est tout simplement de remplacer le server dhcp en coupant l'ancien (physiquement ou via DOS) et remplacer le default router/gateway vers le serveur malicieux. 

#### DHCP Starvation
On DOS le DHCP et ducoup plus personne sur le réseau n'a d'IP automatiquement. ne fonctionne que sur le dhcpv4 et donc avec ipv4 prsk sur du 6 ça marche pas 

Pour s'en protéger on peu activer le DHCP snooping qui permet de bloquer toute les requetes dhcp qui (à complèter)

### DNS
### DNS spoofing

**Remplacer** les données légitimes du cache d'un serveur DNS (ou d'un résolveur) par de fausses informations.

* **Le but :** Détourner le trafic d'un utilisateur vers un site frauduleux (phishing, malware) à son insu, alors qu'il a tapé la bonne URL. On l'appelle aussi *DNS cache poisoning* (empoisonnement de cache).

---

### Rogue DNS

**Remplacer les IP par les** adresses IP de serveurs DNS malveillants contrôlés par l'attaquant.

* **Le mécanisme :** L'attaquant modifie directement la configuration réseau de la victime (via un malware ou en piratant le routeur) pour que toutes ses requêtes DNS soient envoyées à un serveur pirate. Ce serveur "menteur" renvoie ensuite de fausses adresses IP pour n'importe quel site (ex: taper `banque.com` redirige vers l'IP du pirate).

---

### DNS spoofing WAN

** Le **DNS Spoofing sur le WAN** (Wide Area Network) désigne une attaque par usurpation DNS qui cible des réseaux étendus ou Internet, plutôt qu'un simple réseau local (LAN).

* **Comment ça marche :** L'attaquant n'a pas besoin d'être sur le même Wi-Fi que la victime. Il intercepte ou falsifie les communications DNS traversant Internet. Cela se fait souvent par :
* **La prédiction d'ID (Transaction ID ID Guessing) :** L'attaquant bombarde le résolveur DNS public ou d'un FAI de fausses réponses en devinant le numéro de transaction avant que le vrai serveur DNS ne réponde.
* **L'attaque Kaminsky :** Une technique avancée pour forcer un serveur DNS WAN à mettre en cache une fausse entrée de manière durable.

Pour s'en protéger on va utiliser **DNSSec** qui va signer chaque réponse DNS avec un cerertificat. On utilise également **DNSCrypt** qui va chiffrer l'ensemble du trafic DNS. 

Il existe une solution afin d'éviter TOUT TYPES DE SNIFFING/SPOOFING et c'est tout simplement le **CHIFFREMENT**. 

