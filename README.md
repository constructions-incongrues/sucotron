# Le Suçotron

Il aspire pour vous !

Le Suçotron permet d'obtenir simplement et rapidement de grandes quantités de morceaux de musique à partir d'une liste de références approximatives. 

Il a été développé à la base pour répondre aux besoins des contributeurs des projets [Ouïedire](http://www.ouiedire.net) et [Empilements](http://empilements.incongru.org).

Plus concrètement, il permet de gérer des collections de fichiers audio. Chaque collection contient à sa racine un fichier `queries.txt` qui liste des requêtes de recherche Youtube. À l'exécution du script, les requêtes de la collection sélectionnée sont envoyées au moteur de recherche de Youtube. Le premier résultat de chaque recherche est téléchargé et ajouté à la collection.

## Installation

Docker doit être [installé](https://docs.docker.com/install/).

```sh
curl https://raw.githubusercontent.com/constructions-incongrues/sucotron/master/bin/sucotron > ./sucotron
chmod +x ./sucotron
sudo mv ./sucotron /usr/local/bin/sucotron
```

## Utilisation

### Commandes

Le Suçotron s'appuie sur [Make](https://www.gnu.org/software/make/) et expose les commandes suivantes :

- `clean` : Supprime les fichiers audio de la collection
- `help` :  Affiche l'aide en ligne
- `queries` Gère la création, l'import et la modification des fichiers de requête de la collection
- `suce` :  Recherche, télécharge et encode les résultats des recherches du fichier de requêtes de la collection

### Paramètres

- `AUDIO_FORMAT=flac` : Format des fichiers audio générés
- `COLLECTION=default` : Nom de la collection active
- `COLLECTIONS_HOME=./collections` : Chemin vers un dossier destiné à contenir des collections
- `FORCE=false` : Définir à `true` pour déclencher le mode non-interactif. Il sera répondu `oui` à toutes les questions
- `IMPORT_QUERIES=false` : Définir comme le chemin vers un fichier de requêtes existant pour l'importer dans la collection

## Cookbook

### Création d'une nouvelle collection au format MP3

```sh
sucotron suce COLLECTION=macollection AUDIO_FORMAT=mp3
```

### Duplication d'une collection existante dans un autre format audio

```sh
sucotron suce COLLECTION=nouvellecollection IMPORT_QUERIES=./collections/collectionexistante/queries.txt AUDIO_FORMAT=flac
```
