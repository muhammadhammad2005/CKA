kubectl scale deployment sample-app-v3 --replicas=3
kubectl scale deployment sample-app-v1 --replicas=0
kubectl get deployments
