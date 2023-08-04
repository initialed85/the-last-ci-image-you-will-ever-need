#!/usr/bin/env bash

set -e

docker build --progress=plain -t initialed85/the-last-ci-image-you-will-ever-need:latest -f Dockerfile ./

docker image push initialed85/the-last-ci-image-you-will-ever-need:latest
