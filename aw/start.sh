#! /bin/bash

sudo service docker start

ORG=$ORG

ACCESS_TOKEN=$TOKEN

GROUP=$GROUP

REG_TOKEN=$(curl -X POST -H "Authorization: token ${ACCESS_TOKEN}" -H "Accept: application/vnd.github+json" https://api.github.com/orgs/${ORG}/actions/runners/registration-token | jq .token --raw-output)

cd /runner

./config.sh --url https://github.com/${ORG} --token ${REG_TOKEN} --runnergroup ${GROUP}

cleanup() {
    echo "Removing runner ..."
    /config.sh remove --unattended --token ${REG_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!