#! /usr/bin/env bash
eval echo \""$(cat Dockerfile.in)"\" > Dockerfile

docker build -q -t sw .

RUNARGS="-h scraperwiki-$(hostname) "
#RUNARGS="$RUNARGS -v ./custard:/sw/custard "
#RUNARGS="$RUNARGS -v ./cobalt:/sw/cobalt"

ID=$(docker run $RUNARGS -d sw)

ssh -p 2222 localhost

IM=$(docker stop $ID)

echo Docker image: $IM
#echo Docker image: $(docker rm $IM)
