## Intégration de Kubernetes dans les Namespaces

L'objectif de cette tâche était d'étudier la faisabilité de l'intégration de Kubernetes dans un groupement de namespaces. Plusieurs scripts sont disponibles dans le répertoire `scripts/` et sont dédiés à l'étude de cette faisabilité.

Le LIP6 utilise des machines virtuelles avec Debian version 9.12 Stretch et le noyau version 4.9.0-12-amd64. La première étape a consisté à installer Kubernetes sur cette configuration spécifique, ce qui est rendu possible par le script `install-kube.sh` :

```bash
./install-kube.sh
```

Une fois que Kubernetes a été installé avec succès sur la machine virtuelle, la prochaine étape a été de le faire fonctionner au sein d'un groupement de namespaces. Le script `master-ns.sh` facilite la création de différents namespaces et assure la connectivité entre l'hôte et le conteneur :

```bash
./master-ns.sh
```
