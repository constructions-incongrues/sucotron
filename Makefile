.PHONY=clean help queries suce

SHELL=/bin/bash

AUDIO_FORMAT=flac
COLLECTION=default
COLLECTIONS_HOME=./collections
IMPORT_QUERIES=false
FORCE=false

help: ## Affiche ce message d'aide. Une documentation détaillée est disponible à l'adresse suivante : https://github.com/constructions-incongrues/sucotron
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

clean: ## Supprime les fichiers audio de la collection active
	@if [ "$(FORCE)" == "false" ]; then \
		read -e -p "[collections/$(COLLECTION)] Les fichiers audio de la collection active seront supprimés. Êtes-vous sûr⋅e ? [o/N] " RESPONSE; \
		if [ "$$RESPONSE" == "o" ]; then \
			echo "[collections/$(COLLECTION)] Suppression des fichiers audio"; \
			rm -f $(COLLECTIONS_HOME)/$(COLLECTION)/audio/*; \
		fi; \
	else \
		echo "[collections/$(COLLECTION)] Suppression des fichiers audio (forcé)"; \
		rm -f $(COLLECTIONS_HOME)/$(COLLECTION)/audio/*; \
	fi;

collection: ## Gère la création, l'import et la modification de la base de données de requêtes de la collection active
	@if [ "$(IMPORT_QUERIES)" != "false" ] && [ -f "$(IMPORT_QUERIES)" ]; then \
		if [ "$(FORCE)" == "false" ]; then \
			read -e -p "[collections/$(COLLECTION)] La base de requêtes existant sera écrasée. Êtes-vous sûr⋅e ? [o/N] " RESPONSE; \
			if [ "$$RESPONSE" == "o" ]; then \
				echo "[collections/$(COLLECTION)] Import de la base de requêtes (file=$(COLLECTIONS_HOME)/$(COLLECTION)/queries.txt)"; \
				cp "$(IMPORT_QUERIES)" "$(COLLECTIONS_HOME)/$(COLLECTION)/queries.txt"; \
			fi; \
		else \
			echo "[collections/$(COLLECTION)] Import de la base de requêtes (forcé, file=$(COLLECTIONS_HOME)/$(COLLECTION)/queries.txt)"; \
			cp "$(IMPORT_QUERIES)" "$(COLLECTIONS_HOME)/$(COLLECTION)/queries.txt"; \
		fi; \
	fi

	@if [ ! -f "$(COLLECTIONS_HOME)/$(COLLECTION)/queries.txt" ]; then \
		echo "[collections/$(COLLECTION)] Création d'une base de requêtes vide (path=$(COLLECTIONS_HOME)/$(COLLECTION)/queries.txt)"; \
		mkdir -p $(COLLECTIONS_HOME)/$(COLLECTION); \
		touch $(COLLECTIONS_HOME)/$(COLLECTION)/queries.txt; \
	fi

suce: collection youtube-dl ## Recherche, télécharge et encode les résultats des recherches de la base de requêtes de la collection active
	@mkdir -p "$(COLLECTIONS_HOME)/$(COLLECTION)/audio"; \
	NUM_TRACKS=`wc -l $(COLLECTIONS_HOME)/$(COLLECTION)/queries.txt | cut -d' ' -f1`; \
	I=0; \
	while read -r QUERY; do \
		VIDEO_TITLE=`./vendor/youtube-dl "ytsearch:$$QUERY" --get-title`; \
		let "I++"; \
		LEVENSHTEIN_DISTANCE=`levenshtein "$$QUERY" "$$VIDEO_TITLE"`; \
		echo -ne "\r[collections/$(COLLECTION)] [$$I/$$NUM_TRACKS] distance=\"$$LEVENSHTEIN_DISTANCE\" query=\"$$QUERY\" result=\"$$VIDEO_TITLE\" format=\"$(AUDIO_FORMAT)\"\n"; \
		if ! [ -f "$(COLLECTIONS_HOME)/$(COLLECTION)/audio/$$VIDEO_TITLE.$(AUDIO_FORMAT)" ]; then \
			./vendor/youtube-dl \
				"ytsearch:$$QUERY" \
				--audio-format=$(AUDIO_FORMAT) \
				--extract-audio \
				--quiet \
				--output="$(COLLECTIONS_HOME)/$(COLLECTION)/audio/%(title)s.webm)"; \
		fi; \
	done < $(COLLECTIONS_HOME)/$(COLLECTION)/queries.txt;

youtube-dl:
	@if ! [ -f ./vendor/youtube-dl ]; then \
		echo "[sucotron/vendor] Installation de youtube-dl"; \
		curl -LsS "https://yt-dl.org/downloads/2019.01.02/youtube-dl" > ./vendor/youtube-dl; \
    	chmod +x ./vendor/youtube-dl; \
    fi
