#!/bin/bash

DEPLOYMENT_NAME="nginx-deployment"

echo "=== Deployment Status ==="
kubectl get deployment $DEPLOYMENT_NAME
echo ""

echo "=== Rollout Status ==="
kubectl rollout status deployment/$DEPLOYMENT_NAME
echo ""

echo "=== Rollout History ==="
kubectl rollout history deployment/$DEPLOYMENT_NAME
echo ""

echo "=== ReplicaSets ==="
kubectl get replicasets -l app=nginx
echo ""

echo "=== Pods ==="
kubectl get pods -l app=nginx -o wide
echo ""

echo "=== Recent Events ==="
kubectl get events --sort-by='.lastTimestamp' | tail -15
echo ""

echo "=== Deployment Strategy ==="
kubectl describe deployment $DEPLOYMENT_NAME | sed -n '/StrategyType/,/Events/p'
echo ""

echo "=== Analysis Complete ==="
