#!/bin/bash
MINIKUBE_IP=$(minikube ip)

echo "NodePort:"
curl -s -o /dev/null -w "%{http_code}\n" http://$MINIKUBE_IP:30080

echo "Ingress HTTP:"
curl -s -o /dev/null -w "%{http_code}\n" -H "Host: webapp.local" http://localhost:8080

echo "Ingress HTTPS:"
curl -k -s -o /dev/null -w "%{http_code}\n" -H "Host: webapp.local" https://localhost:8443

