# the-last-ci-image-you-will-never-need

# status: working and in production (as part of the Bitbucket CI/CD setup) at my day job

3-odd GB of raw, unadulterated continuous integration goodness- the last CI image you'll ever have to touch.

Not actually true, note even close- just the last CI image I'll ever need for the at least the next few weeks or so.

I got tired of Sh\*tbucket's average CI image and old version of Docker Compose so here we are.

Available on Docker Hub: [initialed85/the-last-ci-image-you-will-ever-need](https://hub.docker.com/r/initialed85/the-last-ci-image-you-will-ever-need).

The following variants are available at different tags:

- `initialed85/the-last-ci-image-you-will-ever-need:everything` (has everything)
  - This is also the default at `initialed85/the-last-ci-image-you-will-ever-need:latest`
- `initialed85/the-last-ci-image-you-will-ever-need:docker` (has just enough to build and push Docker containers)
- `initialed85/the-last-ci-image-you-will-ever-need:kubernetes` (has just enough to do Kubernetes deployments)
- `initialed85/the-last-ci-image-you-will-ever-need:postgres` (has just enough to do some barebones Postgres automation with psql and jq)

## What's it got?

- `everything` / `latest` tags
  - ca-certificates
  - curl
  - tcpdump
  - netcat
  - ping
  - docker
  - node
  - rust
  - go
  - kubectl
  - kustomize
  - atlas
  - python3
  - ripgrep
  - gojsonschema
  - prettier
  - black
  - EAS
  - ssh
  - AWSCLIv2
  - pytest
  - entr
  - git
  - jq
  - nmap
- `docker` tag
  - ca-certificates
  - curl
  - docker
  - git
  - AWSCLIv2
- `kubernetes` tag
  - ca-certificates
  - curl
  - kubectl
  - kustomize
  - prettier
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
