#!/usr/bin/env bash

set -e

#
# build
#

docker rmi initialed85/the-last-ci-image-you-will-ever-need:latest >/dev/null 2>&1 || true
docker build --platform=linux/amd64 --progress=plain -t initialed85/the-last-ci-image-you-will-ever-need:latest -f Dockerfile ./
echo ""

docker rmi initialed85/the-last-ci-image-you-will-ever-need:kubernetes >/dev/null 2>&1 || true
docker build --platform=linux/amd64 --progress=plain -t 'initialed85/the-last-ci-image-you-will-ever-need:kubernetes' -f Dockerfile.kubernetes ./
echo ""

docker rmi initialed85/the-last-ci-image-you-will-ever-need:docker >/dev/null 2>&1 || true
docker build --platform=linux/amd64 --progress=plain -t initialed85/the-last-ci-image-you-will-ever-need:docker -f Dockerfile.docker ./
echo ""

#
# push
#

if [[ "${SKIP_PUSH}" != "1" ]]; then
    docker image push initialed85/the-last-ci-image-you-will-ever-need:latest
    echo ""

    docker image push initialed85/the-last-ci-image-you-will-ever-need:kubernetes
    echo ""

    docker image push initialed85/the-last-ci-image-you-will-ever-need:docker
    echo ""
fi
