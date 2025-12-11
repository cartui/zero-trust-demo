#!/usr/bin/bash
kubectl='minikube kubectl --'

# GATEWAY_HOST=$($kubectl get gtw web-gateway -o jsonpath='{.status.addresses[0].value}')
# GATEWAY_PORT=$($kubectl get gtw web-gateway -o jsonpath='{.spec.listeners[?(@.name=="http")].port}')
INGRESS_HOST=$($kubectl get ingress web-ingress -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

if [[ -z "$INGRESS_HOST" ]]; then
  echo "No address for web-gateway. Is 'minikube tunnel' running?"
else
  echo "Gateway address: http://$INGRESS_HOST/"
  echo ""
  echo "Terminal App: http://$INGRESS_HOST/term"
  echo "Keycloak admin panel: http://$INGRESS_HOST/keycloak"
fi

