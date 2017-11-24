#!/bin/bash
# $1 is target environment name
# $2 is target environment config directory
# $3 is directory to mount as home
CONTAINER_NAME=bxshell-$1-$RANDOM

# if the user is currently in a directory under the $HOME folder
# restore this directory when running in the container
# if not under $HOME, then default to home in the container
function relpath() {
  python -c "import os,sys;print(os.path.relpath(*(sys.argv[1:])))" "$@";
}
RELATIVE_DIR="$(relpath $PWD $HOME)"
if [[ $RELATIVE_DIR == .* ]];
then
  CONTAINER_STARTUP_DIR=/root/mnt/home
else
  CONTAINER_STARTUP_DIR="/root/mnt/home/$RELATIVE_DIR"
fi

# don't pull the latest if instructed
if [ -z "$NO_PULL" ]; then
  docker pull l2fprod/bxshell
fi

docker run -i --privileged \
  --name $CONTAINER_NAME \
  -p 0:8001 \
  -p 0:8080 \
  -p 0:9080 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e BXSHELL_TARGET=$1 \
  -e CONTAINER_NAME=$CONTAINER_NAME \
  -e CONTAINER_STARTUP_DIR="$CONTAINER_STARTUP_DIR" \
  -v $2:/root/mnt/config \
  -v $3:/root/mnt/home \
  -t l2fprod/bxshell
