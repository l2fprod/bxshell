#!/bin/bash
# $1 is target environment name
# $2 is target environment config directory
# $3 is directory to mount as home
CONTAINER_NAME=bxshell-$1-$RANDOM
docker pull l2fprod/bxshell
docker run -i --privileged \
  --name $CONTAINER_NAME \
  -p 0:8001 \
  -p 0:8080 \
  -p 0:9080 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e BXSHELL_TARGET=$1 \
  -e CONTAINER_NAME=$CONTAINER_NAME \
  -v $2:/root/mnt/config \
  -v $3:/root/mnt/home \
  -t l2fprod/bxshell
