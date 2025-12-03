#!/usr/bin/bash
kubectl='minikube kubectl --'

INGRESS_HOST=$($kubectl get gtw web-gateway -o jsonpath='{.status.addresses[0].value}')
# INGRESS_PORT=$($kubectl get gtw web-gateway -o jsonpath='{.spec.listeners[?(@.name=="http")].port}')

if [[ -z "$INGRESS_HOST" ]]; then
  echo "No address for web-gateway. Is 'minikube tunnel' running?"
else
  echo "Gateway address: http://$INGRESS_HOST/"
fi

