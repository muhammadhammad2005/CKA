#!/bin/bash
kubectl get pods -l app=sample-app -o wide
kubectl get endpoints sample-app-service
