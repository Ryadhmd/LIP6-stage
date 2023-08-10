#!/bin/bash

# Version de kubernetes à installer 
version=1.23.17-00
# Lignes à ajouter au fichier sources.list
lines=(
"deb http://archive.debian.org/debian stretch main"
"deb http://archive.debian.org/debian stretch/updates main"
"deb http://archive.debian.org/debian-security stretch/updates main"
)
# Lignes a changer dans le fichier service de Docker
search="ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock"
replace="ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock --exec-opt native.cgroupdriver=systemd"
# path du fichier des pods nginx à deployer 
file="../application/deployment.yaml" 
#-------------------------------------------------
### étape 1: ajouter les repos ###

# Ajouter les lignes au fichier sources.list

## on parcourt lines et on verifie si la ligne est présente dans le fichier si ce n'est pas le cas on l'ajoute
for line in "${lines[@]}"; do
    sudo grep -qxF "$line" /etc/apt/sources.list || sudo echo "$line" >> /etc/apt/sources.list
done

echo "Les lignes ont été ajoutées au fichier /etc/apt/sources.list avec succès."

#-------------------------------------------------
### étape 2 : installer les outils kube ###

### On crée ce dossier car sur cette version de Debian il n'est pas créer par défaut 

mkdir -p /etc/apt/keyrings
sudo apt-get update && apt-get install -y apt-transport-https ca-certificates curl

# Télécharge Google Cloud public signing key 

curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg

# Ajoute Kubernetes apt repository

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Installe kubelet, kubeadm and kubectl avec la version demandée 

sudo apt-get update 
sudo apt-get install -y kubelet=$version kubeadm=$version kubectl=$version
sudo apt-mark hold kubelet kubeadm kubectl

echo "Les outils Kubeadm, Kubelet et Kubectl ont été installés avec succès." 

#-------------------------------------------------
### étape 3: Modifier docker pour utiliser systemd 

# Chemin du fichier à modifier

output=$(sudo systemctl status docker)
file=$(echo "$output" | grep -oP 'Loaded: loaded \K\S+' | tr -d '();')

# Vérifier si la ligne à remplacer existe dans le fichier
if grep -qF "$search" "$file"; then
    # Remplacer la ligne
    sed -i "s|$search|$replace|g" "$file"
    echo "La ligne a été modifiée avec succès."
else
    echo "La ligne à modifier n'a pas été trouvée dans le fichier."
    exit 1
fi

sudo systemctl daemon-reload
sudo systemctl restart docker

echo "Docker a été modifié avec succés afin d'utiliser systemd comme Cgroup." 

#-------------------------------------------------
### etape 4: créer le cluster

# Désactiver le swap 
sed -i '/swap/ s/^/#/' /etc/fstab
swapoff -a 

# Lancer la création du cluster 
kubeadm init --pod-network-cidr=10.244.0.0/16

mkdir -p $HOME/.kube 
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config 
sudo chown $(id -u):$(id -g) $HOME/.kube/config 

echo "Cluster Kubernetes crée avec succés." 
#-------------------------------------------------
### étape 5: appliquer le plugin réseaux

kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml


read -p "Do you want to deploy two nginx pods? (yes/no): " choice

if [[ $choice == "yes" ]]; then
    kubectl apply -f $file
    echo "Execute : 'kubectl get pods' command to see if the deployment succedded"
else
    echo "No deployment executed."
fi


