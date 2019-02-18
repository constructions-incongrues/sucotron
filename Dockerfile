FROM python:alpine

WORKDIR /usr/local/src/sucotron

# Installation des dépendances
RUN apk add --update --no-cache bash build-base curl ffmpeg git make \
    && git clone https://github.com/wooorm/levenshtein \
    && cd levenshtein \
    && make install

# Configuration de fixuid : https://github.com/boxboat/fixuid
# -- Création d'un utilisateur dédié à la synchronisation des uids et gid
RUN addgroup -g 1000 docker && \
    adduser -u 1000 -G docker -h /home/docker -s /bin/sh -D docker

# -- Installation de fixuid
RUN USER=docker && \
    GROUP=docker && \
    curl -SsL https://github.com/boxboat/fixuid/releases/download/v0.4/fixuid-0.4-linux-amd64.tar.gz | tar -C /usr/local/bin -xzf - && \
    chown root:root /usr/local/bin/fixuid && \
    chmod 4755 /usr/local/bin/fixuid && \
    mkdir -p /etc/fixuid

# -- Configuration de fixuid
COPY ./etc/fixuid.yml /etc/fixuid/config.yml

USER docker:docker

COPY --chown=docker:docker . /usr/local/src/sucotron

# Installation d'une version dédiée de youtube-dl
RUN make youtube-dl

# L'exécutable fixuid se charge de synchroniser les uid et gid avant d'exécuter quoique ce soit
ENTRYPOINT  [ "./etc/entrypoint.sh" ]
