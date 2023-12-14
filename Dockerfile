FROM --platform=linux/amd64 ubuntu:22.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

# various
RUN apt-get update && \
    apt-get install -y tcpdump netcat inetutils-ping openssh-client ca-certificates curl tzdata \
    git unzip entr jq tmux gnupg python3 python3-dev python3-pip postgresql-client-14 && \
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
    . /root/.bashrc && nvm alias default v18.17 && nvm install v18.17 && nvm use v18.17 && rm -frv install.sh

# prettier
RUN . /root/.bashrc && npm install -g prettier@latest

# rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > install.sh && \
    chmod +x install.sh && \
    ./install.sh -y && rm -frv install.sh
ENV PATH=${PATH}:/root/.cargo/bin/
RUN rustup update

# go
RUN curl -LO https://go.dev/dl/go1.21.3.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.21.3.linux-amd64.tar.gz && \
    rm -frv go1.21.3.linux-amd64.tar.gz
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

# ripgrep
RUN cargo install ripgrep@13.0.0

# gojsonschema
RUN go install github.com/atombender/go-jsonschema/cmd/gojsonschema@v0.12.0

# black
RUN python3 -m pip install black

# EAS
RUN . /root/.bashrc && npm install -g eas-cli

# AWSCLIv2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -frv awscliv2.zip aws /tmp/*

# pytest
RUN python3 -m pip install pytest

FROM --platform=linux/amd64 scratch

ENV PATH=${PATH}:/root/.cargo/bin/
ENV PATH=${PATH}:/usr/local/go/bin

COPY --link --from=builder / /

WORKDIR /srv

ENV TZ=Etc/UTC

ENTRYPOINT ["/bin/bash"]
CMD []
