#!/bin/bash
if [ -z "$1" ]
then
  echo "Please choose a target:"
  select target in "US" "London" "Frankfurt" "Sydney" "Exit"; do
    case $target in
    "US" )
      export BMX_TARGET=ng
      break;;
    "London" )
      export BMX_TARGET=eu-gb
      break;;
    "Frankfurt" )
      export BMX_TARGET=eu-de
      break;;
    "Sydney" )
      export BMX_TARGET=au-syd
      break;;
    "Exit" )
      exit;;
    esac
  done
else
  export BMX_TARGET=$1
fi

DIR=$(dirname `python -c "import os; print(os.path.realpath('$0'))"`)
echo $DIR

BXSHELL_CONFIG=$HOME/.bxshell
echo "BXSHELL_CONFIG is $BXSHELL_CONFIG"
mkdir -p $BXSHELL_CONFIG

export CONFIG_DIR=$BXSHELL_CONFIG/environments/$BMX_TARGET
mkdir -p $CONFIG_DIR
echo "Environment configuration is $CONFIG_DIR"
touch $CONFIG_DIR/bx-config.json
touch $CONFIG_DIR/cf-config.json

mkdir -p $CONFIG_DIR/container-registry
mkdir -p $CONFIG_DIR/container-service/clusters

$DIR/_bxshell.sh $BMX_TARGET $CONFIG_DIR $HOME
