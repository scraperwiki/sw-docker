#! /usr/bin/env bash

set -e -u

export DOCKER_HOST_IF="$(ip address show docker0 | sed -r -n 's|^.*inet (.*)/.*$|\1|gp')"

# TODO: Later versions of NPM have a list of CAs..
#NPM_CA="$(npm config --global get ca | sed "s| ]|, '$(sed ':a;N;$!ba;s/\n/\\\\n/g' ./mitm-ca.crt)' ]|g")"

NPM_CA="$(sed ':a;N;$!ba;s/\n/\\\\\\\\n/g' ./local/mitm-ca.crt)"

for img in imgs/sw-base imgs/sw
do
  eval echo \""$(cat ${img}/Dockerfile.in)"\" > ${img}/Dockerfile
  (cd $img && time docker build -t "$(basename ${img})" .)
done

# transparent proxy for all docker containers
# sudo iptables -t nat -A PREROUTING -i docker0 -p tcp --dport 80 -j REDIRECT --to-port 3128

RUNARGS=("-h" "scraperwiki-$(hostname)")
RUNARGS+=("-v" "$PWD:/home/$(whoami)/sw-docker" )
RUNARGS+=("-privileged=true")
#RUNARGS="$RUNARGS -v ./custard:/sw/custard "
#RUNARGS="$RUNARGS -v ./cobalt:/sw/cobalt"

ID="$(docker run "${RUNARGS[@]}" -d sw)"

trap cleanup EXIT

function cleanup() {
	IM="$(docker stop $ID)"

	docker rm $IM
	echo "Deleted docker image ($IM)"
}

# HOSTKEY="$(docker run sw cat /etc/ssh/ssh_host_ecdsa_key.pub | cut -d' ' -t1-2)"

# TODO: host key modification
ssh -oStrictHostKeyChecking=no -p 2222 localhost
