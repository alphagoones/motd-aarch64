# Guide d'installation MOTD-AARCH64

Ce guide détaille les différentes méthodes d'installation de MOTD-AARCH64.

## Prérequis

### Système requis
- **Architecture** : aarch64/ARM64 (optimisé pour)
- **OS** : Debian, Ubuntu, Raspberry Pi OS, ou dérivés
- **Privilèges** : Accès root/sudo
- **Espace disque** : ~50MB pour l'installation complète

### Packages requis
Les packages suivants seront installés automatiquement :
- `figlet` - Génération de texte ASCII art
- `bc` - Calculatrice pour les calculs de température
- `dialog` - Interface de configuration interactive
- `lolcat` - Effets de couleurs (optionnel)
- `curl` - Téléchargement de fichiers

## Méthodes d'installation

### 1. Installation rapide (recommandée)

```bash
# Téléchargement et installation en une commande
curl -fsSL https://raw.githubusercontent.com/votre-username/motd-aarch64/main/install.sh | sudo bash
```

### 2. Installation depuis le dépôt Git

```bash
# Cloner le dépôt
git clone https://github.com/votre-username/motd-aarch64.git
cd motd-aarch64

# Rendre le script exécutable
chmod +x install.sh

# Lancer l'installation
sudo ./install.sh
```

### 3. Installation depuis un package .deb

```bash
# Télécharger le package .deb depuis les releases
wget https://github.com/votre-username/motd-aarch64/releases/latest/download/motd-aarch64_1.0.0_arm64.deb

# Installer le package
sudo dpkg -i motd-aarch64_1.0.0_arm64.deb

# Résoudre les dépendances si nécessaire
sudo apt-get install -f
```

### 4. Installation avec Make

```bash
# Cloner et utiliser Make
git clone https://github.com/votre-username/motd-aarch64.git
cd motd-aarch64

# Installation avec Make
make install
```

## Configuration durant l'installation

### 1. Affichage du hostname
L'installateur vous demande si vous souhaitez afficher le hostname en grand dans le MOTD.

**Recommandation** : Oui pour un affichage plus imposant

### 2. Sélection des informations système

Vous pouvez choisir quelles informations afficher :

- ✅ **Système** - Distribution et version
- ✅ **Architecture** - Type de processeur
- ✅ **Noyau** - Version du kernel Linux
- ✅ **Uptime** - Temps de fonctionnement
- ✅ **Charge** - Load average du système
- ✅ **Mémoire** - Utilisation RAM
- ✅ **Disque** - Utilisation stockage
- ✅ **IP** - Adresse IP locale
- ✅ **Température** - Température CPU (si disponible)
- ✅ **Utilisateurs** - Utilisateurs connectés
- ✅ **Lastlog** - Dernières connexions
- ✅ **Mises à jour** - Updates disponibles

**Recommandation** : Activez toutes les options pour un maximum d'informations

### 3. Sélection des services à surveiller

L'installateur détecte automatiquement les services installés :

**Services couramment détectés :**
- `ssh` - Serveur SSH
- `apache2` - Serveur web Apache
- `nginx` - Serveur web Nginx
- `docker` - Conteneurisation Docker
- `fail2ban` - Protection contre les intrusions
- `ufw` - Pare-feu Ubuntu
- `postgresql` - Base de données PostgreSQL
- `mysql` - Base de données MySQL/MariaDB
- `redis` - Cache Redis
- `mongodb` - Base de données MongoDB

**Recommandation** : Sélectionnez tous les services critiques pour votre système

### 4. Choix du thème de couleurs

Quatre thèmes sont disponibles :

- **Défaut** (multicolore) - Cyan/Jaune/Vert/Rouge
- **Bleu** - Variations de bleu
- **Vert** - Variations de vert  
- **Rouge** - Variations de rouge

## Configuration post-installation

### Structure des fichiers créés

```
/etc/motd-aarch64/
├── config              # Configuration générale (thème, hostname)
├── system_info         # Liste des infos système activées
└── services           # Liste des services surveillés

/etc/update-motd.d/
├── 00-motd-aarch64    # Script principal MOTD
└── 10-motd-services   # Script surveillance services
```

### Personnalisation avancée

#### Modifier les informations affichées
```bash
# Éditer les informations système
sudo nano /etc/motd-aarch64/system_info

# Ajouter/retirer des éléments (un par ligne)
system
arch
kernel
uptime
load
memory
disk
ip
temp
users
lastlog
updates
```

#### Modifier les services surveillés
```bash
# Éditer la liste des services
sudo nano /etc/motd-aarch64/services

# Ajouter un service personnalisé
echo "mon-service" | sudo tee -a /etc/motd-aarch64/services
```

#### Changer le thème
```bash
# Éditer la configuration
sudo nano /etc/motd-aarch64/config

# Modifier la ligne THEME
THEME=blue    # ou green, red, default
```

## Commandes utiles

### Gestion de base
```bash
# Tester le MOTD
sudo run-parts /etc/update-motd.d/

# Reconfigurer
sudo ./install.sh --configure

# Désinstaller
sudo ./install.sh --uninstall
```

### Avec Make (si installé depuis Git)
```bash
# Tester
make test

# Reconfigurer
make configure

# Vérifier le statut
make status

# Sauvegarder la config
make backup

# Restaurer une sauvegarde
make restore BACKUP=fichier.tar.gz
```

## Dépannage d'installation

### Erreur : "Architecture non supportée"
```bash
# Vérifier l'architecture
uname -m

# Forcer l'installation (à vos risques)
sudo ./install.sh --force-arch
```

### Erreur : "Packages non trouvés"
```bash
# Mettre à jour les sources
sudo apt update

# Installer manuellement
sudo apt install figlet bc dialog curl
```

### Erreur : "Permissions insuffisantes"
```bash
# Vérifier les permissions sudo
sudo -v

# Relancer avec sudo explicite
sudo bash install.sh
```

### MOTD ne s'affiche pas
```bash
# Vérifier les scripts MOTD
ls -la /etc/update-motd.d/

# Réparer les permissions
sudo chmod +x /etc/update-motd.d/00-motd-aarch64
sudo chmod +x /etc/update-motd.d/10-motd-services

# Tester manuellement
sudo run-parts /etc/update-motd.d/
```

### Services non détectés
```bash
# Lister tous les services
systemctl list-unit-files --type=service

# Vérifier un service spécifique
systemctl status nom-du-service
```

### Température non affichée

#### Pour Raspberry Pi
```bash
# Tester la température
/opt/vc/bin/vcgencmd measure_temp

# Vérifier les capteurs
ls /sys/class/thermal/thermal_zone*/temp
```

#### Pour autres SBC ARM
```bash
# Vérifier les capteurs disponibles
find /sys -name "*temp*" -type f 2>/dev/null
cat /sys/class/thermal/thermal_zone0/temp
```

## Désinstallation

### Désinstallation complète
```bash
# Avec le script d'installation
sudo ./install.sh --uninstall

# Ou avec Make
make uninstall
```

### Désinstallation manuelle
```bash
# Supprimer les scripts MOTD
sudo rm -f /etc/update-motd.d/00-motd-aarch64
sudo rm -f /etc/update-motd.d/10-motd-services

# Supprimer la configuration
sudo rm -rf /etc/motd-aarch64

# Réactiver l'ancien MOTD (optionnel)
sudo chmod +x /etc/update-motd.d/*
```

## Support

En cas de problème :

1. Consultez ce guide de dépannage
2. Vérifiez les [Issues GitHub](https://github.com/votre-username/motd-aarch64/issues)
3. Créez une nouvelle issue avec :
   - Sortie de `uname -a`
   - Contenu de `/etc/os-release`
   - Logs d'erreur complets
   - Configuration actuelle
