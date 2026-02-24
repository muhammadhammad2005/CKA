#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <version>"
  exit 1
fi

VER="$1"
IMAGE_NAME="localhost:5000/webapp:$VER"

echo "Building Docker image..."
docker build -t webapp-opt:$VER -f Dockerfile.multistage .

echo "Tagging image for local registry..."
docker tag webapp-opt:$VER $IMAGE_NAME

echo "Pushing image to local registry..."
docker push $IMAGE_NAME

echo "Updating Kubernetes deployment..."
kubectl set image deploy/webapp webapp=$IMAGE_NAME -n lab

echo "Waiting for rollout to complete..."
kubectl rollout status deploy/webapp -n lab

echo "✅ Deployment updated to version $VER"
