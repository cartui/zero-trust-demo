#!/usr/bin/bash

# We have to build images for the kubernetes cluster
# separately, because k8s typically expects to pull images
# from a registry (as you usually have more than one
# node). For one local node we don't need that, instead 
# just build images locally and load them to minikube's
# local cache.

minikube image build -t simple-website:latest images/simple-website
