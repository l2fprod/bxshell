# bxshell - All the Bluemix tools I need in one Docker image and a few shell scripts

[![Build Status](https://travis-ci.org/l2fprod/bxshell.svg)](https://travis-ci.org/l2fprod/bxshell)

**bxshell** is made of one Docker image where the Bluemix CLI and its plugin have been preinstalled together with the CLI to work with containers. **bxshell** also provides a script to start the Docker image and to mount configuration directories into the image.

![screen.png](./screen.png)

---

## Requirements

* Python 2.7.10
* Docker Engine

> Tested on macOS Sierra 10.12.6 with Docker 17.06.1-ce-mac24 (18950)

## Install

1. Clone the repository

   ```
   git clone https://github.com/l2fprod/bxshell
   ```

1. Add `bxshell/bin` directory to your path

1. Ensure your Docker engine is running

1. Start the shell for an environment with `bxenv.sh <env_name>`

   ```
   bxenv.sh us-south
   ```

   This retrieves the **bxshell** Docker image and starts a container.

## How it works

On your host, **bxshell** stores configuration files under `$HOME/.bxshell` where it creates one subfolder per environment. Under these folders, you'll find several configuration files created by the Docker container as you use the various Bluemix CLI and other scripts there.

Use `bxenv.sh <env_name>` to start a new shell on the environment `env_name`. Environment name is arbitrary. You can use any name. This is only a way to keep configuration files together.

`bxenv.sh` calls `bxshell.sh` which in turn runs the Docker container interactively. The container will die when you quit the shell.

`bxshell.sh` starts the Docker container with privileged mode and expose the local Docker socket inside the container so you can build images there too.

`bxshell.sh` mounts your $HOME directory and the $HOME/.bxshell/environments directory under /root/mnt in the container. This way you can access your files from within the container.

## Environment Customization

Under $HOME/.bxshell/<env_name> you can create a .env_profile file to perform additional initialization when bxshell starts.

## Tools included in bxshell

The exact list can be found by looking at the [Dockerfile](Dockerfile).

* cURL
* wget
* jq
* docker
* nvm
* node.js 6.9.1
* node.js latest
* Bluemix CLI and cloud-functions, container-registry, container-service, dev, schematics plugins
* kubectl
* istio
* helm

---

The program is provided as-is with no warranties of any kind, express or implied.
