FROM nestybox/ubuntu-noble-systemd-docker

ARG RUNNER_VERSION="2.322.0"

# Prevents installdependencies.sh from prompting the user and blocking the image creation
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -y \
    curl \
    jq \
    sudo \
    unzip \
    wget \
    zip \
    git \
    && rm -rf /var/lib/apt/list/*

# Add and config runner user as sudo
# Remove default admin user
# https://github.com/nestybox/dockerfiles/blob/master/ubuntu-focal-systemd/Dockerfile
RUN useradd -m runner \
    && usermod -aG sudo runner \
    && usermod -aG docker runner \
    && echo "%sudo   ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers \
    && userdel -r admin

RUN apt install -y --no-install-recommends \
curl jq build-essential libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip libicu-dev

# Install and configure UTF-8 locales
RUN apt-get update && apt-get install -y locales

RUN sed -i -e 's/# es_ES.UTF-8 UTF-8/es_ES.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen es_ES.UTF-8

ENV LANG='es_ES.UTF-8' LANGUAGE='es_ES:es' LC_ALL='es_ES.UTF-8'

# Install your software here #
##############################

WORKDIR /runner

# Download and extract actions runner software
RUN curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
&& tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

RUN ./bin/installdependencies.sh && rm -rf /var/lib/apt/lists/*

WORKDIR /

COPY start.sh /usr/local/bin/

# make the script executable
RUN chmod +x /usr/local/bin/start.sh

USER runner

ENTRYPOINT ["start.sh"]