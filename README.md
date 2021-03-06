<p align="center">
  <img src="sucotron.gif">
</p>

## Présentation

Le Suçotron permet d'obtenir simplement et rapidement de grandes quantités de morceaux de musique à partir d'une liste de références approximatives.

Plus concrètement, il permet de gérer des collections de fichiers audio. Chaque collection contient à sa racine un fichier `queries.txt` qui liste des requêtes de recherche Youtube. À l'exécution du script, les requêtes de la collection sélectionnée sont envoyées au moteur de recherche de Youtube. Le premier résultat de chaque recherche est téléchargé et ajouté à la collection.

Il a été développé à la base pour répondre aux besoins des contributeurs des projets [Ouïedire](http://www.ouiedire.net) et [Empilements](http://empilements.incongru.org).

Le Suçotron est un projet du collectif [Constructions Incongrues](http://www.constructions-incongrues.net).

### Exemple d'utilisation

```sh
# Création d'un dossier pour héberger les collections sur la machine hôte
mkdir collections

# Création d'une collection intitulée "chansonstristes" avec une base de requêtes vide
sucotron collection COLLECTION=chansonstristes

# Ajout de requêtes au fichier
echo "La chanson d'Hélène Piccoli" > ./collections/chansonstristes/queries.txt
echo "Ce soir je m'en vais Jacqueline Taiebbe" >> ./collections/chansonstristes/queries.txt
echo "J'ai le cafard Damia" >> ./collections/chansonstristes/queries.txt
echo "Pépé Léo Ferré" >> ./collections/chansonstristes/queries.txt

# Recherche, téléchargement et conversion en fichier des meileurs résultats
sucotron suce COLLECTION=chansonstristes > sucotron.log
```

La commande précédente génère cette sortie (la distance permet de se faire une idée approximative de la similarité entre la requête et le titre du meilleur résultat) :

```text
# cat sucotron.log
[collections/chansonstristes] [1/4] distance="41" query="La chanson d'Hélène Piccoli" result="Romy Schneider & Michel Piccoli "La chanson d'Hélène"" format="flac"
[collections/chansonstristes] [2/4] distance="9" query="Ce soir je m'en vais Jacqueline Taiebbe" result="Ce Soir Je M'en Vais by Jacqueline Taieb" format="flac"
[collections/chansonstristes] [3/4] distance="6" query="J'ai le cafard Damia" result="J'ai le cafard" format="flac"
[collections/chansonstristes] [4/4] distance="3" query="Pépé Léo Ferré" result="Pépée - Léo Ferré" format="flac"
```

Les fichiers audio au format MP3 ont bien été ajoutés à la collection :

```text
# ls -lh collections/chansonstristes/audio/
total 113M
-rw-r--r-- 1 tristan tristan 25M nov.   7  2014 "Ce Soir Je M'en Vais by Jacqueline Taieb.flac"
-rw-r--r-- 1 tristan tristan 22M sept. 29  2017 "J'ai le cafard.flac"
-rw-r--r-- 1 tristan tristan 50M oct.  31 22:29 'Pépée - Léo Ferré.flac'
-rw-r--r-- 1 tristan tristan 17M sept. 21 13:52 'Romy Schneider & Michel Piccoli '\''La chanson d'\''Hélène'\''.flac'
```

## Installation

Docker doit être [installé](https://docs.docker.com/install/) au préalable.

Vous pouvez dorénavant installer le Suçotron :

```sh
curl -sSL https://raw.githubusercontent.com/constructions-incongrues/sucotron/master/dist/sucotron > ./sucotron
chmod +x ./sucotron
sudo mv ./sucotron /usr/local/bin/sucotron
```

### Gestion de versions multiples

Par défaut, l'exécutable `sucotron` utilise la dernière version stable connue du Suçotron. Il est possible de choisir facilement la version à utiliser à l'aide de la variable d'environnement `SUCOTRON_VERSION` :

- Occasionnellement, en la faisant précéder l'appel de l'exécutable : `SUCOTRON_VERSION=1.15.0 sucotron version`
- De manière permanente, en l'ajoutant au profil de configuration au démarrage de votre shell : `echo SUCOTRON_VERSION=1.15.0 >> ~/.basrc`

## Utilisation

### Commandes

Le Suçotron s'appuie entre autres sur [Make](https://www.gnu.org/software/make/) et l'utilise pour exposer les commandes suivantes :

- `clean` : Supprime les fichiers audio de la collection active
- `collection` Gère la création, l'import et la modification de la base de données de requêtes de la collection
- `help` :  Affiche l'aide en ligne
- `suce` :  Recherche, télécharge et encode les résultats des recherches émises depuis la base de requêtes de la collection active

### Paramètres

- `AUDIO_FORMAT=flac` : Format des fichiers audio générés
- `COLLECTION=default` : Nom de la collection active
- `COLLECTIONS_HOME=./collections` : Chemin vers un dossier destiné à contenir des collections
- `FORCE=false` : Définir à `true` pour déclencher le mode non-interactif. Il sera répondu `oui` à toutes les questions
- `IMPORT_QUERIES=false` : Définir comme le chemin vers une base de requêtes existante pour l'importer dans la collection

## Recettes

### Création d'une nouvelle collection au format MP3

```sh
sucotron suce COLLECTION=macollection AUDIO_FORMAT=mp3
```

### Duplication d'une collection existante dans un autre format audio

```sh
sucotron suce COLLECTION=nouvellecollection IMPORT_QUERIES=./collections/collectionexistante/queries.txt AUDIO_FORMAT=flac
```
