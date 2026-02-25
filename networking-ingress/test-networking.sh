#!/bin/bash
MINIKUBE_IP=$(minikube ip)

echo "NodePort:"
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://$MINIKUBE_IP:30080)
if [ "$HTTP_CODE" -eq 200 ]; then
  echo "✓ NodePort accessible (HTTP 200)"
else
  echo "✗ NodePort inaccessible (HTTP $HTTP_CODE)"
fi

echo "Ingress HTTP:"
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -H "Host: webapp.local" http://localhost:8080)
if [ "$HTTP_CODE" -eq 200 ]; then
  echo "✓ Ingress HTTP accessible (HTTP 200)"
else
  echo "✗ Ingress HTTP inaccessible (HTTP $HTTP_CODE)"
fi

echo "Ingress HTTPS:"
HTTP_CODE=$(curl -k -s -o /dev/null -w "%{http_code}" -H "Host: webapp.local" https://localhost:8443)
if [ "$HTTP_CODE" -eq 200 ]; then
  echo "✓ Ingress HTTPS accessible (HTTP 200)"
else
  echo "✗ Ingress HTTPS inaccessible (HTTP $HTTP_CODE)"
fi
