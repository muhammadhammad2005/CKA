#!/bin/bash

echo "=== Canary Deployment Monitor ==="
echo "Timestamp: $(date)"
echo "---------------------------------"

echo ""
echo "📦 Pods by Version:"
kubectl get pods -l app=sample-app -L version

echo ""
echo "📊 Deployment Status:"
kubectl get deploy -l app=sample-app

echo ""
echo "🌐 Service Endpoints:"
kubectl get endpoints sample-app-service -o wide

echo ""
echo "❤️ Pod Health (Ready Status):"
kubectl get pods -l app=sample-app \
  -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.containerStatuses[*].ready}{"\n"}{end}'

echo ""
echo "---------------------------------"
echo "Monitor complete"
