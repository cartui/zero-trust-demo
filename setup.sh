#!/usr/bin/bash

minikube addons enable istio-provisioner
minikube addons enable istio

kubectl="minikube kubectl --"

$kubectl label namespace default opa-istio-injection="enabled"
$kubectl label namespace default istio-injection="enabled"
$kubectl label namespace pomerium istio-injection="enabled"

echo -e "\nSetup done. Now building images"
./build.sh

echo -e "\n Applying configuration"
$kubectl delete -f manifest
$kubectl apply -f manifest

