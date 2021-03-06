# Participer au développement

Récupérer les sources du projet :

```sh
git clone https://github.com/constructions-incongrues/sucotron
```

## Commandes

Les commandes liées au cycle de vie du projet sont regroupées dans le fichier [Makefile.dev](Makefile.dev).

- `build` : Génère une image Docker à partir des sources du projet
- `help` : Affiche ce message d'aide. Une documentation détaillée est disponible à l'adresse suivante : https://github.com/constructions-incongrues/sucotron
- `push` : Publie l'image Docker dans son registre
- `release` : Crée et publie une nouvelle version du projet

## Paramètres

- `IMAGE=constructionsincongrues/sucotron` : Nom de l'image Docker
- `VERSION=` : Une version d'application au format [SemVer](https://semver.org/)

## Tests

La suite de tests est implémentée dans la cible `test` du fichier [`Makefile.dev`](Makefile.dev).

On l'exécute avec la commande `docker-compose build && docker-compose run sucotron make -f Makefile.dev test`.

## Recettes

### Reconstruire l'image du Suçotron

```sh
docker-compose build
```

### Tester des modifications faites aux commandes

```sh
docker-compose run sucotron <commande>
```

### Publication d'une nouvelle version

```sh
make -f Makefile.dev release TAG=x.y.z
```

Cette commande va créer et publier un nouveau tag Git ce qui déclenche les phases de test et de publication d'une nouvelle image Docker le cas échéant : <https://cloud.docker.com/u/constructionsincongrues/repository/registry-1.docker.io/constructionsincongrues/sucotron>