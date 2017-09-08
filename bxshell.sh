#!/bin/bash
docker run -i --privileged \
  -p 8001:8001 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e BXSHELL_TARGET=$BMX_TARGET \
  -v $CONFIG_DIR:/root/mnt/config \
  -v $HOME:/root/mnt/home \
  -t l2fprod/bxshell
