---
name: 🐛 Rapport de bug
about: Signaler un problème avec MOTD-AARCH64
title: '[BUG] '
labels: 'bug'
assignees: ''
---

## 🐛 Description du bug

Une description claire et concise du problème rencontré.

## 🔄 Étapes de reproduction

Étapes pour reproduire le comportement :
1. Aller à '...'
2. Exécuter '....'
3. Voir l'erreur

## ✅ Comportement attendu

Une description claire de ce qui devrait se passer.

## ❌ Comportement actuel

Une description claire de ce qui se passe réellement.

## 🖼️ Captures d'écran

Si applicable, ajoutez des captures d'écran pour illustrer le problème.

## 🖥️ Environnement

**Système :**
- OS : [ex. Ubuntu 22.04, Raspberry Pi OS]
- Architecture : [ex. aarch64]
- Matériel : [ex. Raspberry Pi 4, Orange Pi]
- Version MOTD-AARCH64 : [ex. 1.0.0]

**Configuration :**
- Thème utilisé : [ex. default, blue]
- Services surveillés : [ex. ssh, docker]
- Informations système activées : [ex. toutes, minimales]

## 📋 Logs d'erreur

```
Coller les logs d'erreur ici
```

## 🔧 Configuration actuelle

<details>
<summary>Configuration MOTD</summary>

```bash
# Contenu de /etc/motd-aarch64/config
[Coller le contenu ici]

# Contenu de /etc/motd-aarch64/system_info
[Coller le contenu ici]

# Contenu de /etc/motd-aarch64/services
[Coller le contenu ici]
```

</details>

## 🧪 Tests effectués

- [ ] Testé avec `sudo run-parts /etc/update-motd.d/`
- [ ] Vérifié les permissions des fichiers
- [ ] Testé la reconfiguration
- [ ] Redémarré le service SSH

## 📝 Informations additionnelles

Ajoutez tout contexte supplémentaire concernant le problème ici.

## ☑️ Checklist

- [ ] J'ai vérifié qu'il n'y a pas d'issue similaire existante
- [ ] J'ai fourni toutes les informations demandées
- [ ] J'ai testé avec la dernière version disponible
- [ ] J'ai inclus les logs d'erreur complets
