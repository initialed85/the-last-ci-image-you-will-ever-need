# the-last-ci-image-you-will-never-need

# status: in production at my old job (part of some Bitbucket Pipelines) and in production at my house

Nearly 4GB of hardcore uncensored continuous integration goodness- the last CI image you'll ever have to touch.

Not true of course, not even close- just the last CI image I'll ever need for the at least the next ~~few weeks~~ year
or so.

I got tired of Sh\*tbucket's average CI image and old version of Docker Compose so here we are.

Available on Docker Hub:
[initialed85/the-last-ci-image-you-will-ever-need](https://hub.docker.com/r/initialed85/the-last-ci-image-you-will-ever-need).

The following variants are available at different tags:

- `initialed85/the-last-ci-image-you-will-ever-need:everything`
  - Maximal image targeting everything except for fast spin-up time (because it takes forever to download)
- `initialed85/the-last-ci-image-you-will-ever-need:docker`
  - Minimal image targeting Docker-in-Docker automation
- `initialed85/the-last-ci-image-you-will-ever-need:kubernetes`
  - Minimal image targeting Kubernetes deployments
- `initialed85/the-last-ci-image-you-will-ever-need:postgres`
  - Minimal image targeting some Postgres automation with `jq`
- `initialed85/the-last-ci-image-you-will-ever-need:postgres-and-kubernetes`
  - Minimal image targeting Postgres automation and Kubernetes automation with `jq`

Of note, `initialed85/the-last-ci-image-you-will-ever-need:latest` points to
`initialed85/the-last-ci-image-you-will-ever-need:everything`.

## What's it got?

- `everything`
  - tcpdump
  - netcat
  - inetutils-ping
  - openssh-client
  - ca-certificates
  - curl
  - tzdata
  - git
  - unzip
  - entr
  - jq
  - tmux
  - gnupg
  - python3
  - python3-dev
  - python3-pip
  - postgresql-client-14
  - docker
  - node
  - prettier
  - rust
  - go
  - staticcheck
  - dotenv
  - kubectl
  - kustomize
  - atlas
  - ripgrep
  - gojsonschema
  - black
  - EAS
  - AWSCLIv2
  - pytest
  - goimports
- `docker`
  - ca-certificates
  - curl
  - tzdata
  - git
  - unzip
  - gnupg
  - docker-ce
  - docker-ce-cli
  - containerd.io
  - docker-buildx-plugin
  - docker-compose-plugin
  - AWSCLIv2
- `kubernetes`
  - ca-certificates
  - curl
  - tzdata
  - git
  - unzip
  - node
  - prettier
  - kubectl
  - kustomize
  - AWSCLIv2
- `postgres`
  - postgresql-client-14
  - jq
- `postgres-and-kubernetes`
  - postgresql-client-14
  - jq
  - ca-certificates
  - curl
  - tzdata
  - git
  - unzip
  - node
  - prettier
  - kubectl
  - kustomize
  - AWSCLIv2

## Where should the code go?

The working directory is `/srv`, so that's where you should mount / copy / whatever your code to.

## Can you show me how to use it as a Docker container?

```shell
docker run --rm -it --privileged \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $(pwd):/srv \
  initialed85/the-last-ci-image-you-will-ever-need:everything \
  bash -c 'go build -o your-app ./cmd && docker compose up -d && go test -v ./... ; retval=${?} ; docker compose down --remove-orphans --volumes ; exit ${retval}'
```

## I want some more stuff in it

Raise an issue on this repo and I'll add it- hopefully I've got CI for building this image sorted by then.

(Edit: 1 year ago, lol- still no CI for the CI image)
