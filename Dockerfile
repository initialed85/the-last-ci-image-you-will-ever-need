FROM --platform=linux/amd64 ubuntu:22.04 AS builder

# ca-certificates, curl, tcpdump, netcat, ping
RUN apt-get update && \
    apt-get install -y ca-certificates curl tzdata tcpdump netcat inetutils-ping

# docker
RUN apt-get update && \
    apt-get install -y ca-certificates curl gnupg && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    chmod a+r /etc/apt/keyrings/docker.gpg && \
    echo \
      "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
      tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# node
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash && \
    . /root/.bashrc && nvm alias default v18.17 && nvm install v18.17 && nvm use v18.17

# rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > install.sh && \
  chmod +x install.sh && \
  ./install.sh -y
ENV PATH=${PATH}:/root/.cargo/bin/
RUN rustup update

# go
RUN curl -LO https://dl.google.com/go/go1.20.7.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.20.7.linux-amd64.tar.gz
ENV PATH=${PATH}:/usr/local/go/bin

# kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    mv kubectl /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl

# kustomize
RUN curl -sL "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash && \
    mv kustomize /usr/local/bin/kustomize && \
    chmod +x /usr/local/bin/kustomize

# atlas
RUN curl -sSf https://atlasgo.sh | sh

# python3
RUN apt-get update && \
    apt-get install -y python3 python3-dev python3-pip

# ripgrep
RUN cargo install ripgrep@13.0.0

# gojsonschema
RUN go install github.com/atombender/go-jsonschema/cmd/gojsonschema@v0.12.0

# prettier
RUN . /root/.bashrc && npm install -g prettier@latest

# black
RUN python3 -m pip install black

# EAS
RUN . /root/.bashrc && npm install -g eas-cli

# ssh
RUN apt-get update && apt-get install -y openssh-client

# AWSCLIv2
RUN apt-get update && \
    apt-get install -y unzip && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install

# pytest
RUN python3 -m pip install pytest

# entr, git, jq, nmap
RUN apt-get update && \
    apt-get install -y entr git jq tmux

# cleanup
RUN rm -frv go1.20.7.linux-amd64.tar.gz awscliv2.zip aws /tmp/*

WORKDIR /srv

# this just turns it all into a single layer with the hope that it'll provide a slight image size optimisation
FROM --platform=linux/amd64 ubuntu:22.04

COPY --from=builder / /

WORKDIR /srv/

ENV PATH=${PATH}:/root/.cargo/bin/
ENV PATH=${PATH}:/usr/local/go/bin
