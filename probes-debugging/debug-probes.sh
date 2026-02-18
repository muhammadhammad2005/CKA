#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <pod-name>"
    exit 1
fi

POD_NAME=$1

echo "=== DEBUGGING POD: $POD_NAME ==="
echo ""

echo "1. Pod Status:"
kubectl get pod $POD_NAME -o wide
echo ""

echo "2. Pod Conditions:"
kubectl get pod $POD_NAME -o jsonpath='{.status.conditions[*]}' | python3 -m json.tool 2>/dev/null || kubectl get pod $POD_NAME -o yaml | grep -A 20 "conditions:"
echo ""

echo "3. Container Status:"
kubectl get pod $POD_NAME -o jsonpath='{.status.containerStatuses[*]}' | python3 -m json.tool 2>/dev/null || kubectl get pod $POD_NAME -o yaml | grep -A 10 "containerStatuses:"
echo ""

echo "4. Recent Events:"
kubectl get events --field-selector involvedObject.name=$POD_NAME --sort-by='.lastTimestamp' | tail -10
echo ""

echo "5. Probe Configuration:"
kubectl get pod $POD_NAME -o yaml | grep -A 15 "Probe:"
echo ""

echo "6. Recent Logs (last 20 lines):"
kubectl logs $POD_NAME --tail=20
echo ""

echo "=== DEBUG COMPLETE ==="
