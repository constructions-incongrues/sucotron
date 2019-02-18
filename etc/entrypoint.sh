#!/bin/sh

./vendor/youtube-dl --update
fixuid -q $@
