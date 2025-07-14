# MOTD-AARCH64 Makefile

.PHONY: help install configure uninstall test clean package

# Variables
INSTALL_SCRIPT = ./install.sh
VERSION = $(shell grep "^# Version:" install.sh | cut -d' ' -f3 || echo "1.0.0")
PACKAGE_NAME = motd-aarch64-$(VERSION)

# Couleurs pour l'affichage
RED = \033[0;31m
GREEN = \033[0;32m
YELLOW = \033[1;33m
BLUE = \033[0;34m
NC = \033[0m # No Color

help: ## Afficher cette aide
	@echo -e "$(BLUE)MOTD-AARCH64 - Commandes disponibles:$(NC)"
	@echo ""
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_-]+:.*##/ {printf "  $(GREEN)%-15s$(NC) %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""

install: ## Installer MOTD-AARCH64
	@echo -e "$(YELLOW)Installation de MOTD-AARCH64...$(NC)"
	@sudo $(INSTALL_SCRIPT)
	@echo -e "$(GREEN)Installation terminée !$(NC)"

configure: ## Reconfigurer MOTD-AARCH64
	@echo -e "$(YELLOW)Reconfiguration de MOTD-AARCH64...$(NC)"
	@sudo $(INSTALL_SCRIPT) --configure
	@echo -e "$(GREEN)Reconfiguration terminée !$(NC)"

uninstall: ## Désinstaller MOTD-AARCH64
	@echo -e "$(YELLOW)Désinstallation de MOTD-AARCH64...$(NC)"
	@sudo $(INSTALL_SCRIPT) --uninstall
	@echo -e "$(GREEN)Désinstallation terminée !$(NC)"

test: ## Tester le MOTD
	@echo -e "$(YELLOW)Test du MOTD...$(NC)"
	@sudo run-parts /etc/update-motd.d/
	@echo -e "$(GREEN)Test terminé !$(NC)"

lint: ## Vérifier la syntaxe des scripts
	@echo -e "$(YELLOW)Vérification de la syntaxe...$(NC)"
	@if command -v shellcheck >/dev/null 2>&1; then \
		shellcheck install.sh; \
		echo -e "$(GREEN)Syntaxe correcte !$(NC)"; \
	else \
		echo -e "$(RED)shellcheck non installé, installation...$(NC)"; \
		sudo apt install -y shellcheck; \
		shellcheck install.sh; \
	fi

clean: ## Nettoyer les fichiers temporaires
	@echo -e "$(YELLOW)Nettoyage...$(NC)"
	@rm -f *.tmp *.log *.backup
	@rm -rf build/ dist/
	@echo -e "$(GREEN)Nettoyage terminé !$(NC)"

package: clean ## Créer un package de distribution
	@echo -e "$(YELLOW)Création du package $(PACKAGE_NAME)...$(NC)"
	@mkdir -p dist
	@tar -czf dist/$(PACKAGE_NAME).tar.gz \
		install.sh \
		README.md \
		LICENSE \
		.gitignore \
		Makefile \
		--transform 's,^,$(PACKAGE_NAME)/,'
	@echo -e "$(GREEN)Package créé : dist/$(PACKAGE_NAME).tar.gz$(NC)"

deb: ## Créer un package .deb (nécessite fpm)
	@echo -e "$(YELLOW)Création du package .deb...$(NC)"
	@if ! command -v fpm >/dev/null 2>&1; then \
		echo -e "$(RED)fpm non installé. Installation...$(NC)"; \
		sudo apt install -y ruby ruby-dev rubygems build-essential; \
		sudo gem install fpm; \
	fi
	@mkdir -p build/usr/local/bin
	@cp install.sh build/usr/local/bin/motd-aarch64-install
	@chmod +x build/usr/local/bin/motd-aarch64-install
	@fpm -s dir -t deb \
		-n motd-aarch64 \
		-v $(VERSION) \
		-a arm64 \
		--description "MOTD moderne pour architecture aarch64" \
		--url "https://github.com/votre-username/motd-aarch64" \
		--maintainer "Votre nom <votre.email@example.com>" \
		--license "MIT" \
		--depends "figlet" \
		--depends "bc" \
		--depends "dialog" \
		-C build \
		.
	@mv *.deb dist/
	@echo -e "$(GREEN)Package .deb créé dans dist/$(NC)"

check-deps: ## Vérifier les dépendances
	@echo -e "$(YELLOW)Vérification des dépendances...$(NC)"
	@echo -n "figlet: "
	@if command -v figlet >/dev/null 2>&1; then echo -e "$(GREEN)✓$(NC)"; else echo -e "$(RED)✗$(NC)"; fi
	@echo -n "bc: "
	@if command -v bc >/dev/null 2>&1; then echo -e "$(GREEN)✓$(NC)"; else echo -e "$(RED)✗$(NC)"; fi
	@echo -n "dialog: "
	@if command -v dialog >/dev/null 2>&1; then echo -e "$(GREEN)✓$(NC)"; else echo -e "$(RED)✗$(NC)"; fi
	@echo -n "lolcat: "
	@if command -v lolcat >/dev/null 2>&1; then echo -e "$(GREEN)✓$(NC)"; else echo -e "$(RED)✗$(NC)"; fi

install-deps: ## Installer les dépendances de développement
	@echo -e "$(YELLOW)Installation des dépendances de développement...$(NC)"
	@sudo apt update
	@sudo apt install -y shellcheck ruby ruby-dev rubygems build-essential
	@sudo gem install fpm
	@echo -e "$(GREEN)Dépendances installées !$(NC)"

status: ## Afficher le statut de l'installation
	@echo -e "$(BLUE)Statut de MOTD-AARCH64:$(NC)"
	@echo ""
	@if [ -d "/etc/motd-aarch64" ]; then \
		echo -e "$(GREEN)✓ Installé$(NC)"; \
		echo -e "Configuration: /etc/motd-aarch64/"; \
		echo -e "Scripts MOTD: /etc/update-motd.d/"; \
	else \
		echo -e "$(RED)✗ Non installé$(NC)"; \
	fi
	@echo ""

backup: ## Sauvegarder la configuration actuelle
	@echo -e "$(YELLOW)Sauvegarde de la configuration...$(NC)"
	@if [ -d "/etc/motd-aarch64" ]; then \
		sudo tar -czf motd-aarch64-config-backup-$(shell date +%Y%m%d-%H%M%S).tar.gz \
			-C /etc motd-aarch64/ \
			-C /etc/update-motd.d 00-motd-aarch64 10-motd-services 2>/dev/null || true; \
		echo -e "$(GREEN)Sauvegarde créée !$(NC)"; \
	else \
		echo -e "$(RED)Aucune configuration à sauvegarder$(NC)"; \
	fi

restore: ## Restaurer une sauvegarde (BACKUP=fichier.tar.gz)
	@if [ -z "$(BACKUP)" ]; then \
		echo -e "$(RED)Erreur: Spécifiez le fichier de sauvegarde avec BACKUP=fichier.tar.gz$(NC)"; \
		exit 1; \
	fi
	@echo -e "$(YELLOW)Restauration de $(BACKUP)...$(NC)"
	@sudo tar -xzf $(BACKUP) -C /
	@echo -e "$(GREEN)Restauration terminée !$(NC)"

dev-setup: install-deps ## Configuration de l'environnement de développement
	@echo -e "$(YELLOW)Configuration de l'environnement de développement...$(NC)"
	@git config --local core.autocrlf false
	@git config --local core.eol lf
	@echo -e "$(GREEN)Environnement de développement configuré !$(NC)"

release: lint package deb ## Créer une release complète
	@echo -e "$(GREEN)Release $(VERSION) créée avec succès !$(NC)"
	@echo -e "Fichiers générés:"
	@ls -la dist/

# Variables par défaut
VERSION ?= 1.0.0
BACKUP ?=
