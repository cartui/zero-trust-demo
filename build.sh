#!/usr/bin/bash

# We have to build images for the kubernetes cluster
# separately, because k8s typically expects to pull images
# from a registry (as you usually have more than one
# node). For one local node we don't need that, instead 
# just build images locally and load them to minikube's
# local cache.

# Gotta start the cluster first otherwise minikube image build doesnt work
minikube status > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "Cluster is not running, make sure you run 'minikube start' before building"
fi

minikube image build -t simple-website:latest images/simple-website

if [[ -z "$(ls -A images/docker-ttyd)" ]]; then
  git submodule update --init
fi
minikube image build -t ttyd:latest images/docker-ttyd
