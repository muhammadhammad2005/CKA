#!/bin/bash
kubectl get deployments -l app=sample-app
kubectl get pods -l app=sample-app -o wide
kubectl get services -l app=sample-app
kubectl get events --sort-by=.metadata.creationTimestamp | tail -10
kubectl top pods -l app=sample-app 2>/dev/null || echo "Metrics server not available"
kubectl rollout history deployment/sample-app-v1
kubectl rollout history deployment/sample-app-v3
