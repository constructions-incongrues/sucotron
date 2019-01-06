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
- `TAG=latest` : Tag de l'image Docker

## Cookbook

### Tester des modifications en cours

```sh
docker-compose run sucotron <commande>
```

### Publication d'une nouvelle version

```sh
make -f Makefile.dev release TAG=x.y.z
```
