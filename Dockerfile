FROM ubuntu:24.04

ARG RUNNER_VERSION="2.320.0"
ARG SPOTBUGS_VERSION="4.8.6"

# Prevents installdependencies.sh from prompting the user and blocking the image creation
ARG DEBIAN_FRONTEND=noninteractive

RUN apt update -y && apt upgrade -y && useradd -m docker

RUN apt install -y --no-install-recommends \
curl jq build-essential libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip libicu-dev ant git-all

# Install and configure UTF-8 locales
RUN apt-get update && apt-get install -y locales

RUN sed -i -e 's/# es_ES.UTF-8 UTF-8/es_ES.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen es_ES.UTF-8

ENV LANG='es_ES.UTF-8' LANGUAGE='es_ES:es' LC_ALL='es_ES.UTF-8'

# Install PowerShell (needed for some actions)
# Install pre-requisite packages.
RUN apt-get update && apt-get install -y wget apt-transport-https software-properties-common

# Download the Microsoft repository keys and install it
RUN wget -q https://packages.microsoft.com/config/ubuntu/24.04/packages-microsoft-prod.deb && dpkg -i packages-microsoft-prod.deb && rm packages-microsoft-prod.deb

# Update the list of packages after we added packages.microsoft.com and install powershell
RUN apt-get update && apt-get install -y powershell

RUN apt install -y ant maven git

RUN mkdir -p /home/docker/actions-runner

WORKDIR /home/docker/actions-runner

# Download and extract SpotBugs
RUN curl -O -L https://github.com/spotbugs/spotbugs/releases/download/${SPOTBUGS_VERSION}/spotbugs-${SPOTBUGS_VERSION}.tgz && gunzip -c spotbugs-${SPOTBUGS_VERSION}.tgz | tar xvf -

# Download and extract actions runner software
RUN curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
&& tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

RUN chown -R docker ~docker && /home/docker/actions-runner/bin/installdependencies.sh

WORKDIR /

COPY start.sh start.sh

# make the script executable
RUN chmod +x start.sh

# since the config and run script for actions are not allowed to be run by root,
# set the user to "docker" so all subsequent commands are run as the docker user
USER docker
ENTRYPOINT ["./start.sh"]