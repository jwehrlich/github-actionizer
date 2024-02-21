#! /bin/bash

REPO=${REPO}
ACCESS_TOKEN=${ACCESS_TOKEN}

echo "Retrieving repo token..."
REG_TOKEN=$(curl -L -X POST --url "https://api.github.com/repos/${REPO}/actions/runners/registration-token" \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  | jq .token --raw-output)

cd /home/docker/actions-runner

echo "Configuration runner..."
./config.sh --unattended --disableupdate --replace --url https://github.com/${REPO} --token ${REG_TOKEN} --labels ${LABELS} --name "${BASE_SERVICE_NAME}-${HOSTNAME}"

cleanup() {
  echo "Removing runner..."
  ./config.sh remove --unattended --token ${REG_TOKEN}
}

trap 'cleanup; exit 0'   EXIT
trap 'cleanup; exit 3'   SIGQUIT
trap 'cleanup; exit 130' INT
trap 'cleanup; exit 130' SIGINT
trap 'cleanup; exit 137' SIGKILL
trap 'cleanup; exit 143' TERM
trap 'cleanup; exit 143' SIGTERM

echo "Start action runner server..."
./run.sh & wait
