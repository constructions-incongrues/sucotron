.PHONY=clean default help queries suce

SHELL=/bin/bash

AUDIO_FORMAT=flac
COLLECTION=default
COLLECTIONS_HOME=./collections
EDIT_QUERIES=false
IMPORT_QUERIES=false
FORCE=false

default: help

clean: ## Supprime les fichiers audio de la collection
	@if [ "$(FORCE)" == "false" ]; then \
		read -r -e -p "[collections/$(COLLECTION)] Les fichiers audio de la collection seront supprimés. Êtes-vous sûr⋅e ? [o/N] " RESPONSE; \
	fi; \
	if [ "$(FORCE)" == "true" ] || [ "$$RESPONSE" == "o" ]; then \
		echo "[collections/$(COLLECTION)] Suppression des fichiers audio"; \
		rm -f "$(COLLECTIONS_HOME)/$(COLLECTION)/audio/*"; \
	fi

help: ## Affiche ce message d'aide. Une documentation détaillée est disponible à l'adresse suivante : https://github.com/constructions-incongrues/sucotron
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

queries: ## Gère la création, l'import et la modification des fichiers de requête de la collection
	@if [ "$(IMPORT_QUERIES)" != "false" ] && [ -f "$(IMPORT_QUERIES)" ]; then \
		if [ "$(FORCE)" == "false" ]; then \
			read -r -e -p "[collections/$(COLLECTION)] Le fichier de requêtes existant sera écrasé. Êtes-vous sûr⋅e ? [o/N] " RESPONSE; \
		fi; \
		if [ "$(FORCE)" == "true" ] || [ "$$RESPONSE" == "o" ]; then \
			echo "[collections/$(COLLECTION)] Import du fichier de requêtes"; \
			cp "$(IMPORT_QUERIES)" "$(COLLECTIONS_HOME)/$(COLLECTION)/queries.txt"; \
		fi; \
	fi

	@if [ -f "$(COLLECTIONS_HOME)/$(COLLECTION)/queries.txt" ] && [ "$(EDIT_QUERIES)" == "true" ]; then \
		echo "[collections/$(COLLECTION)] Édition du fichier de requêtes"; \
		editor $(COLLECTIONS_HOME)/$(COLLECTION)/queries.txt; \
	fi

	@if [ ! -f "$(COLLECTIONS_HOME)/$(COLLECTION)/queries.txt" ]; then \
		echo "[collections/$(COLLECTION)] Création du fichier de requêtes"; \
		mkdir -p $(COLLECTIONS_HOME)/$(COLLECTION); \
		editor $(COLLECTIONS_HOME)/$(COLLECTION)/queries.txt; \
	fi

suce: queries youtube-dl ## Recherche, télécharge et encode les résultats des recherches du fichier de requêtes de la collection
	@echo "[collections/$(COLLECTION)] Début du suçottement"
	@mkdir -p "$(COLLECTIONS_HOME)/$(COLLECTION)/audio"; \
	NUM_TRACKS=`wc -l $(COLLECTIONS_HOME)/$(COLLECTION)/queries.txt | cut -d' ' -f1`; \
	I=0; \
	while read -r QUERY; do \
		VIDEO_TITLE=`./vendors/youtube-dl "ytsearch:$$QUERY" --get-title`; \
		let "I++"; \
		echo -ne "\r[collections/$(COLLECTION)] [$$I/$$NUM_TRACKS] $$QUERY (format=$(AUDIO_FORMAT))\n"; \
		if ! [ -f "$(COLLECTIONS_HOME)/$(COLLECTION)/audio/$$VIDEO_TITLE.$(AUDIO_FORMAT)" ]; then \
			./vendors/youtube-dl \
				"ytsearch:$$QUERY" \
				--audio-format=$(AUDIO_FORMAT) \
				--extract-audio \
				--quiet \
				--output="$(COLLECTIONS_HOME)/$(COLLECTION)/audio/%(title)s.webm)"; \
		fi; \
	done < $(COLLECTIONS_HOME)/$(COLLECTION)/queries.txt;
	@echo "[collections/$(COLLECTION)] Fin du suçottement"

youtube-dl:
	@if ! [ -f ./vendors/youtube-dl ]; then \
		curl -LS# "https://yt-dl.org/downloads/2019.01.02/youtube-dl" > ./vendors/youtube-dl; \
    	chmod +x ./vendors/youtube-dl; \
    fi
