#!/bin/bash
docker build --build-arg GITHUB_TOKEN=${GITHUB_TOKEN} -t l2fprod/bxshell .
