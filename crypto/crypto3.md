# crypto 3

Un annuaire doit être intègre. 

Une Autorité de confiance ne doit jamais générer la clé privé. 

résistance d'un mdp = taille de l'aphabet puissance nombre de caractères 

sur un mdp de 10 caractères de l'alphabet basique => 26^10

on parle de log2(N^L) :
- N nombre de caractères possible 
- L longeur du mot de passe 
- log2 algorithme pour mettre ne base2

ceci n'est valable que si tout est tiré aléatoirement on parle de robustesse maximale 

### l'Authentification entre 2 serveurs s'appelle une Authentification mutuelle

- B -> s'authentifie -> A
- A -> s'authentifie -> B

## Échange de clés 

KEM => chiffré une clé symétrique via de l’asymétrique

### Échange de clé Diffie-Hellman (1976)

Clé secrète entre

le problème du log discret, connaisant g, p, g^x(p), il est difficile de trouver le secret x

### Notes importantes 
- un chiffrement authentifié signifie un chiffrement intègre par exemple => AES-128-CBC + AES-128-EMAC | HMAC-SHA3-512 
 
