#!/bin/bash

echo "=== Pod Testing Script ==="
echo "Timestamp: $(date)"
echo "---------------------------------"

echo ""
echo "📦 All Pods:"
kubectl get pods

echo ""
echo "🔍 Checking sidecar-pod logs (log-processor):"
if kubectl get pod sidecar-pod &>/dev/null; then
  kubectl logs sidecar-pod -c log-processor || echo "Failed to fetch logs"
else
  echo "sidecar-pod not found"
fi

echo ""
echo "🔍 Checking ambassador-pod logs (main-app):"
if kubectl get pod ambassador-pod &>/dev/null; then
  kubectl logs ambassador-pod -c main-app || echo "Failed to fetch logs"
else
  echo "ambassador-pod not found"
fi

echo ""
echo "🌐 Testing advanced-pod web-server connectivity:"
if kubectl get pod advanced-pod &>/dev/null; then
  kubectl exec advanced-pod -c web-server -- curl -s http://localhost \
    || echo "Failed to connect to web server"
else
  echo "advanced-pod not found"
fi

echo ""
echo "---------------------------------"
echo "Testing complete"
