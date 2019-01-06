FROM python:alpine

WORKDIR /usr/local/src/sucotron

RUN apk add --update --no-cache bash build-base curl ffmpeg git make \
    && git clone https://github.com/wooorm/levenshtein \
    && cd levenshtein \
    && make install

COPY . /usr/local/src/sucotron

RUN make youtube-dl

ENTRYPOINT [ "make" ]