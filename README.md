# bxshell - All the IBM Cloud tools I need in one Docker image and a few shell scripts

[![Build Status](https://travis-ci.org/l2fprod/bxshell.svg)](https://travis-ci.org/l2fprod/bxshell)

**bxshell** is made of one Docker image where the IBM Cloud CLI, its plugins and commonly used tools have been preinstalled.

- **No more hassle downloading and installing CLIs** - all you need to be productive should already be there;
- **bxshell Docker image is rebuilt weekly with the latest versions**;
- **Multiple environments on the same machine** - open shell windows on multiple user accounts, multiple orgs with no conflict or side-effects;
- **Access your local files from the shell**

![screen.png](./screen.png)

---

## Requirements

* Docker Engine

> Tested on macOS Big Sur with Docker Engine - Community 20.10.5

## Install

1. Clone the repository

   ```
   git clone https://github.com/l2fprod/bxshell
   ```

1. Add `bxshell/bin` directory to your path

1. Ensure your Docker engine is running

1. Start the shell for an environment with `bxshell <env_name>`

   ```
   bxshell us-south
   ```

   This retrieves the **bxshell** Docker image and starts a container.

1. Once in the shell, run `bx login` as you would normally do, change account, org, space.

1. Eventually, quit the shell with `exit`

1. Restart the shell `bxshell us-south` to restore account, org, space

1. Run multiple environments in parallel in different shells

## How it works

On your host, **bxshell** stores configuration files under `$HOME/.bxshell` where it creates one subfolder per environment. Under these folders, you'll find several configuration files created by the Docker container as you use the various IBM Cloud CLI and other scripts there.

Use `bxshell <env_name>` to start a new shell on the environment `env_name`. Environment name is arbitrary. You can use any name. This is only a way to keep configuration files together.

`bxshell` runs the Docker container interactively. The container will die when you quit the shell. It starts the Docker container with privileged mode and expose the local Docker socket inside the container so you can build images there too.

`bxshell` also mounts your `$HOME` directory and the `$HOME/.bxshell/environments directory` under /root/mnt in the container. This way you can access your files from within the container.

## Tips and tricks

### Bash Autocomplete

To autocomplete existing environment names, add the next lines to your Bash startup script:

   ```sh
   # bxshell autocomplete
   source <bxshell-checkout-directory>/bin/.bxshell-bash-completion.sh
   ```

### Skip pulling the latest image

Use `bxshell -l <env_name>` to use the current Docker image in your local registry.

### Transient environment

Use `bxshell -t` to run the Docker container with no mount and no persistent storage.

### Remove an environment

To remove an environment simply delete its directory:

   ```sh
   rm -r $HOME/.bxshell/environments/<environment>
   ```

### Environment Customization

#### Global env file

You can define global environment variables passed to all sessions by editing `$HOME/.bxshell/global.env`.

Example:
   ```
   BXSHELL_ENABLE_POWERLINE=1
   LANG=en_US.utf8
   ```

### Local customization

Under `$HOME/.bxshell/environments/<env_name>` you can create a `.env_profile` file to perform additional initialization when bxshell starts.

### Using powerline shell

**bxshell** comes with experimental support for [Powerline shell](https://github.com/b-ryan/powerline-shell/).

1. Add `BXSHELL_ENABLE_POWERLINE=1` to the global.env file
1. Download and install a [Powerline patched font](https://github.com/powerline/fonts). I use DejaVu
1. Configure your shell to use this font.

This is my configuration for iTerm 2:
![text](iterm-preferences-text.png)

## Tools included in bxshell

The exact list can be found by looking at the [installation script](install.sh).

* IBM Cloud CLI and cloud-functions, functions shell, container-registry, container-service, dev, plugins
* cURL
* docker
* helm
* istio
* jq
* kubectl
* kubetail
* node.js
* nodemon
* nvm
* serverless framework and plugin
* tfswitch
* wget
* yarn

---

The program is provided as-is with no warranties of any kind, express or implied.
