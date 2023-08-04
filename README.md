# the-last-ci-image-you-will-never-need

3-odd GB of raw, unadulterated continuous integration goodness- the last CI image you'll ever have to touch.

Not actually true, note even close- just the last CI image I'll ever need for the at least the next few weeks or so.

I got tired of Sh*tbucket's average CI image and old version of Docker Compose so here we are.

## What's it got?

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

## Where should the code go?

The working directory is `/srv`, so that's where you should mount / copy / whatever your code to.

## Can you show me how to use it as a Docker container?

```shell
docker run --rm -it --privileged \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $(pwd):/srv \
  initialed85/the-last-ci-image-you-will-ever-need:latest \
  bash -c 'go build -o your-app ./cmd && docker compose up -d && go test -v ./... ; retval=${?} ; docker compose down --remove-orphans --volumes ; exit ${retval}'
```

## I want some more stuff in it

Raise an issue on this repo and I'll add it- hopefully I've got CI for building this image sorted by then.
