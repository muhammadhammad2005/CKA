#!/bin/bash

echo "=== Persistent Volumes ==="
kubectl get pv -o custom-columns=NAME:.metadata.name,CAPACITY:.spec.capacity.storage,ACCESS:.spec.accessModes,STATUS:.status.phase,CLAIM:.spec.claimRef.name

echo -e "\n=== Persistent Volume Claims ==="
kubectl get pvc -o custom-columns=NAME:.metadata.name,STATUS:.status.phase,VOLUME:.spec.volumeName,CAPACITY:.status.capacity.storage,ACCESS:.status.accessModes

echo -e "\n=== Pods with Volumes ==="
kubectl get pods -o custom-columns=NAME:.metadata.name,STATUS:.status.phase,VOLUMES:.spec.volumes[*].name

echo -e "\n✅ Volume monitoring complete."
