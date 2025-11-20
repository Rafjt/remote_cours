# 🧠 CRYPTO – COURS 1

## 🔧 1. Construction cryptographique

Une **construction cryptographique** est généralement composée de :

```
PRIMITIVE  +  MODE OPÉRATOIRE
```

* La **primitive** est l’algorithme fondamental (ex : AES, SHA-256, RSA…).
* Le **mode opératoire** définit **comment** on utilise cette primitive pour obtenir une propriété donnée :

  * **Intégrité → MAC**
  * **Confidentialité → modes de chiffrement (CBC, GCM, etc.)**

---

## 🔒 2. Modes opératoires

### 2.1. Intégrité (MAC — Message Authentication Code)

Un MAC permet de vérifier qu’un message n'a pas été modifié et qu’il provient bien du détenteur de la clé.

#### ✔ HMAC (Hash-Based MAC)

* Basé sur une fonction de hachage (SHA-2, SHA-3…)
* Très utilisé (TLS, JWT, API keys…)
* Avantages :

  * Simple, efficace
  * Sécurité bien étudiée
  * Pas de contraintes sur la taille du message

---

#### ✔ CBC-MAC

* Repose sur une **primitive de chiffrement par bloc** (AES, 3DES…)
* Sécurité basée sur la robustesse de la permutation sous-jacente
* **Très important :**

  * Sécurisé uniquement si la taille des messages est **fixe**
  * Sinon, vulnérable à des attaques d’allongement

---

#### ✔ EMAC

* Variante sécurisée de CBC-MAC
* Utilise une clé supplémentaire ou des transformations pour supprimer la contrainte de taille de message
* Sécurisé même pour des messages de tailles variables

---

### 2.2. Confidentialité (Chiffrement)

Les modes opératoires appliqués à une **primitive de chiffrement par bloc**.

#### ✔ CBC (Cipher Block Chaining)

* Chaque bloc dépend du bloc précédent
* Sécurisé *si* :

  * IV aléatoire
  * Padding correct
* Vulnérable aux attaques par bit-flipping sur le premier bloc si non authentifié → **d’où AES-GCM aujourd’hui**

---

#### ❌ ECB (Electronic Codebook)

* Chaque bloc est chiffré indépendamment
* **À ne jamais utiliser** : révèle la structure du message
  (le célèbre exemple du pingouin de Linux)

---

## 🔑 3. Primitives cryptographiques

### ✔ Primitive de chiffrement par bloc

* Une **permutation pseudo-aléatoire** (PRP)
* Entrée et sortie de même taille (AES-128 → 128 bits → 16 octets)
* Exemples :

  * AES (128/192/256 bits)
  * 3DES
* Utilisées pour :

  * Modes de chiffrement (CBC, CTR…)
  * MAC (CBC-MAC, EMAC)

---

### ✔ RSA (asymétrique)

* Primitive de **chiffrement** / **signature**
* Basée sur la factorisation
* Très sensible aux oracles et mauvais padding
  (→ PKCS#1 v1.5 abandonné, utilisation d'OAEP / PSS)

---

## 🔐 4. Cryptologie, cryptographie et cryptanalyse

* **Cryptologie**
  → domaine global : cryptographie + cryptanalyse

* **Cryptographie symétrique**

  * Rapide
  * Très efficace
  * Pas de partage public de clé
  * ❌ pas de non-répudiation
    (car les deux parties possèdent la même clé)

* **Cryptographie asymétrique**

  * Lente
  * Pour petites données
  * Permet d’échanger des clés
  * ✔ permet la **signature** → non-répudiation

---

## ⚛ Ordis quantiques et sécurité

* Une machine quantique casserait **l'asymétrique actuelle** (RSA, ECC)

  * via Shor → factorisation et logarithmes discrets
* La **cryptographie symétrique** tient encore :

  * AES-128 → sécurité équivalente à AES-64 quantique
    (Grover → complexité √N)
  * On compense en augmentant les tailles de clés.

---

## 🕵️ 5. Stéganographie

* En stéganographie, **le secret est le protocole**, pas l'algorithme.
* Objectif : *cacher l’existence* d’un message (pas seulement le chiffrer).

---

## 🛡 6. Paramètres de sécurité

Les principaux paramètres à considérer :

* **Taille de clé**
  (128, 192, 256 bits → force brute)
* **Taille de bloc**
  (128 bits pour AES → limite les collisions dans les modes)
* **Taille d'empreinte**
  (SHA-256 → 256 bits)
* **Facteur de sécurité**
  (résistance aux attaques connues)
* **Indépendance des clés**
  (séparation des usages : chiffrement, MAC, dérivation…)

---

## 📌 7. Sécurité des MAC et signatures

### ➤ MAC

* Attaques possibles :

  * **Contrefaçon universelle**
    → générer un MAC valide sans connaître la clé
  * **Contrefaçon existentielle**
    → produire *au moins un* message contrefait

### ➤ Signatures

* Même typologie :

  * Contrefaçon universelle
    → signer n’importe quoi
  * Contrefaçon existentielle
    → signer un message inattendu

---

## 🧬 8. Propriétés de sécurité des fonctions de hachage

### ✔ Résistance à la pré-image

Trouver *un* message `m` tel que :

```
H(m) = h
```

---

### ✔ Résistance à la seconde pré-image

Trouver un **m2**, donné **m1**, tel que :

```
H(m1) = H(m2)
```

---

### ✔ Résistance aux collisions

Trouver **m1** et **m2** *distincts* tels que :

```
H(m1) = H(m2)
```

(Plus difficile que la seconde pré-image en théorie, mais attaquable via birthday paradox)

---

# ✔ FIN DU COURS 1

*(Contrôle aux prochains cours)*

