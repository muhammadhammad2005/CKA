#!/bin/bash

echo "=== Testing webapp-service-account permissions ==="
echo "Can get pods: $(kubectl auth can-i get pods --as=system:serviceaccount:default:webapp-service-account)"
echo "Can list services: $(kubectl auth can-i list services --as=system:serviceaccount:default:webapp-service-account)"
echo "Can get secrets: $(kubectl auth can-i get secrets --as=system:serviceaccount:default:webapp-service-account)"
echo "Can create pods: $(kubectl auth can-i create pods --as=system:serviceaccount:default:webapp-service-account)"

echo ""
echo "=== Testing database-service-account permissions ==="
echo "Can get secrets: $(kubectl auth can-i get secrets --as=system:serviceaccount:default:database-service-account)"
echo "Can get pods: $(kubectl auth can-i get pods --as=system:serviceaccount:default:database-service-account)"
echo "Can create pods: $(kubectl auth can-i create pods --as=system:serviceaccount:default:database-service-account)"
echo "Can get services: $(kubectl auth can-i get services --as=system:serviceaccount:default:database-service-account)"
