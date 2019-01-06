FROM python:alpine

WORKDIR /usr/local/src/sucotron

# Install dependencies
RUN apk add --update --no-cache bash build-base curl ffmpeg git make \
    && git clone https://github.com/wooorm/levenshtein \
    && cd levenshtein \
    && make install

# fixuid setup : https://github.com/boxboat/fixuid
RUN addgroup -g 1000 docker && \
    adduser -u 1000 -G docker -h /home/docker -s /bin/sh -D docker

RUN USER=docker && \
    GROUP=docker && \
    curl -SsL https://github.com/boxboat/fixuid/releases/download/v0.4/fixuid-0.4-linux-amd64.tar.gz | tar -C /usr/local/bin -xzf - && \
    chown root:root /usr/local/bin/fixuid && \
    chmod 4755 /usr/local/bin/fixuid && \
    mkdir -p /etc/fixuid

COPY ./etc/fixuid.yml /etc/fixuid/config.yml

USER docker:docker

COPY --chown=docker:docker . /usr/local/src/sucotron

RUN make youtube-dl

ENTRYPOINT ["fixuid", "-q"]