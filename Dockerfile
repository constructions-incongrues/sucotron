FROM python:alpine

WORKDIR /usr/local/src/sucotron

RUN apk add --update --no-cache bash curl ffmpeg git make

COPY . /usr/local/src/sucotron

RUN make youtube-dl

ENTRYPOINT [ "make" ]