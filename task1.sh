#!/bin/bash

### étape 1: ajouter les repos ###

# Vérifier si l'utilisateur est root
if [[ $EUID -ne 0 ]]; then
   echo "Ce script doit être exécuté en tant que root."
   exit 1
fi

# Lignes à ajouter
lines=(
"deb http://archive.debian.org/debian stretch main"
"deb http://archive.debian.org/debian stretch/updates main"
"deb http://archive.debian.org/debian-security stretch/updates main"
)

# Ajouter les lignes au fichier sources.list
for line in "${lines[@]}"; do
    grep -qxF "$line" /etc/apt/sources.list || echo "$line" >> /etc/apt/sources.list
done

# Mettre à jour les sources
apt update

echo "Les lignes ont été ajoutées au fichier /etc/apt/sources.list avec succès."


### étape 2 : installer les outils kube ###

mkdir /etc/apt/keyrings
chmod 
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl

curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet=1.23.17-00 kubeadm=1.23.17-00 kubectl=1.23.17-00
sudo apt-mark hold kubelet kubeadm kubectl

### étape 3: Modifier docker pour utiliser systemd 
# Chemin du fichier à modifier
file="/etc/systemd/system/docker.service"

# Ligne à rechercher
search="ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock"

# Ligne de remplacement
replace="ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock --exec-opt native.cgroupdriver=systemd"

# Vérifier si la ligne à remplacer existe dans le fichier
if grep -qF "$search" "$file"; then
    # Remplacer la ligne
    sed -i "s|$search|$replace|g" "$file"
    echo "La ligne a été modifiée avec succès."
else
    echo "La ligne à modifier n'a pas été trouvée dans le fichier."
    exit 1
fi
systemctl daemon-reload
systemctl restart docker

### etape 4: créer le cluster
sed -i '/swap/ s/^/#/' /etc/fstab
swapoff -a 
kubeadm init --pod-network-cidr=10.244.0.0/16


### étape 5: 
kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml


