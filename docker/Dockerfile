FROM --platform=linux/amd64 ubuntu:20.04

ARG RUNNER_VERSION="2.313.0"
ARG DEBIAN_FRONTEND=noninteractive

RUN apt update -y && apt upgrade -y software-properties-common
RUN add-apt-repository main && \
  add-apt-repository universe && \
  add-apt-repository restricted && \
  add-apt-repository multiverse

RUN apt update -y && apt install -y --no-install-recommends curl jq build-essential \
  libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip

ARG WORKSPACE=/home/docker/actions-runner
RUN useradd -m docker
WORKDIR ${WORKSPACE}

RUN mkdir -p ${WORKSPACE} && cd ${WORKSPACE} \
  && curl -o actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
  && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

RUN chown -R docker ~docker && ${WORKSPACE}/bin/installdependencies.sh

COPY start.sh start.sh

# since the config and run script for actions are not allowed to be run by root,
# set the user to "docker" so all subsequent commands are run as the docker user
USER docker

ENTRYPOINT ["./start.sh"]
