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

echo "2. Pod Conditions (Ready/Initialized/ContainersReady):"
kubectl get pod $POD_NAME -o jsonpath='{range .status.conditions[*]}{.type}: {.status}{"\n"}{end}'
echo ""

echo "3. Container Status (restarts, state, last termination reason):"
kubectl get pod $POD_NAME -o jsonpath='{range .status.containerStatuses[*]}{.name}{"\t"}{.ready}{"\t"}{.restartCount}{"\t"}{.state}{"\t"}{.lastState}{"\n"}{end}' | python3 -m json.tool 2>/dev/null || kubectl get pod $POD_NAME -o yaml | grep -A 10 "containerStatuses:"
echo ""

echo "4. Recent Events (last 20):"
kubectl get events --field-selector involvedObject.name=$POD_NAME --sort-by='.lastTimestamp' | tail -20
echo ""

echo "5. Probe Configuration:"
kubectl get pod $POD_NAME -o yaml | yq e '.spec.containers[].livenessProbe, .spec.containers[].readinessProbe' - 2>/dev/null || echo "Probes not defined"
echo ""

echo "6. Recent Logs (last 50 lines for all containers):"
CONTAINERS=$(kubectl get pod $POD_NAME -o jsonpath='{.spec.containers[*].name}')
for c in $CONTAINERS; do
    echo "--- Logs for container: $c ---"
    kubectl logs $POD_NAME -c $c --tail=50
    echo ""
done

echo "=== DEBUG COMPLETE ==="
