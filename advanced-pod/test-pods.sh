#!/bin/bash
kubectl get pods
kubectl logs sidecar-pod -c log-processor
kubectl logs ambassador-pod -c main-app
kubectl exec advanced-pod -c web-server -- curl -s http://localhost
