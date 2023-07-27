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

## Configuration de AWS 
Afin de pouvoir connecter les objects IoT à AWS IoT certaines taches de configurations sont necessaires, pour cela rendez-vous dans le service IoT core depuis votre Console de Management AWS



