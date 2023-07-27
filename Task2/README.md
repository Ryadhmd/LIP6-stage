# AWS IoT Contiki

Le but de cette tâche est de récupérer des métriques depuis des objets IoT émulés par le simulateur Cooja fourni par Contiki-OS et de les publier sur le Cloud en utilisant AWS IoT.

## Installation d'Instant-Contiki

Instant-Contiki est une machine virtuelle pré-configurée avec tous les outils et logiciels nécessaires pour le développement sous ContikiOS.

### Téléchargement de la machine virtuelle

Vous pouvez télécharger la machine virtuelle à partir du lien suivant : [Télécharger Instant-Contiki 3.0](https://sourceforge.net/projects/contiki/files/Instant%20Contiki/Instant%20Contiki%203.0/)

La machine virtuelle est basée sur Ubuntu 14.04 LTS avec une version de noyau 3.13. La version de Python utilisée et prise en charge ici est la version 3.4.3.

### Configuration de la machine virtuelle

Après avoir téléchargé la machine virtuelle, extrayez le contenu en utilisant la commande suivante :

```bash
unzip InstantContiki3.0.zip
```

Ensuite, ouvrez le fichier .vmx avec VMware (ou tout autre logiciel de virtualisation) et lancez la machine virtuelle. 

**IMPORTANT:** Pour vous connecter à Instant Contiki, utilisez les informations suivantes :
- **Nom d'utilisateur:** user
- **Mot de passe:** user

N'oubliez pas de mettre à jour les paquets du système en exécutant les commandes suivantes dans le terminal de la machine virtuelle :

```bash
sudo apt update
sudo apt upgrade
```
## Récupération du code source

Pour commencer, clonez ce repository en utilisant la commande `git clone` :

```bash
git clone https://github.com/Ryadhmd/LIP6-stage.git
```

Ensuite, déplacez-vous dans le répertoire `LIP6-stage/Task2` à l'aide de la commande `cd` :

```bash
cd LIP6-stage/Task2
```

Créez ensuite un dossier nommé `aws-creds` à l'aide de la commande `mkdir` :

```bash
mkdir aws-creds
```
## Configuration d'AWS

Afin de pouvoir connecter les objets IoT à AWS IoT, certaines tâches de configuration sont nécessaires. Accédez à votre Console de Management AWS et recherchez le service "IoT Core" dans la barre de recherche ou trouvez-le dans la section "Internet of Things" (IoT).

### Étape 1 : Créer une politique de sécurité
Dans le menu de gauche, cliquez sur "Sécurité" puis sur "Stratégie", cliquez ensuite sur "Créer".

<img src="images/create-policy.png" alt="Politique AWS" width="1000" height="800" />

1. Donnez un nom à votre politique, par exemple "PolitiqueContiki" ou "Contiki".
2. Dans la section "Action", sélectionnez les actions que vous souhaitez autoriser pour cette politique. Dans notre exemple nous avons séléctionner * afin d'autoriser toutes les actions AWS IoT ce qui est utile pour les tests. Cependant, il est préférable d'améliorer la sécurité pour une configuration en production. Pour des exemples de politiques plus sécurisées, consultez les [exemples de politiques AWS IoT](https://docs.aws.amazon.com/iot/latest/developerguide/example-iot-policies.html)

3. Dans la section "Ressource ARN", spécifiez les ressources auxquelles cette politique s'applique. Vous pouvez laisser l'option par défaut * pour appliquer la politique à toutes les ressources IoT.

4. Enfin sous "Effet", choisissez "Autoriser" pour permettre les actions spécifiées par la politique.

### Étape 2 : Créer un objet IoT 


