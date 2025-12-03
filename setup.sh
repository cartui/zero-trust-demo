#!/usr/bin/bash

minikube addons enable istio-provisioner
minikube addons enable istio

kubectl="minikube kubectl --"

$kubectl label namespace default opa-istio-injection="enabled"
$kubectl label namespace default istio-injection="enabled"

$kubectl apply --server-side -f server-manifest/gateway-crd.yaml

echo -e "\nSetup done. Now building images"
./build.sh
