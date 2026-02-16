#!/bin/bash
VER=$1
docker build -t webapp-opt:$VER -f Dockerfile.multistage .
docker tag webapp-opt:$VER localhost:5000/webapp:$VER
docker push localhost:5000/webapp:$VER
kubectl set image deploy/webapp webapp=localhost:5000/webapp:$VER -n lab
kubectl rollout status deploy/webapp -n lab
