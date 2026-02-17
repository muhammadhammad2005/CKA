#!/bin/bash
BACKEND_IP=$(kubectl get pod backend -n netpol-lab -o jsonpath='{.status.podIP}')
FRONTEND_IP=$(kubectl get pod frontend -n netpol-lab -o jsonpath='{.status.podIP}')
echo "Backend IP: $BACKEND_IP, Frontend IP: $FRONTEND_IP"

kubectl exec -n netpol-lab frontend -- timeout 5 nc -zv $BACKEND_IP 5432 && echo "✓ Frontend→Backend OK" || echo "✗ Frontend→Backend FAIL"
kubectl exec -n netpol-lab test-client -- timeout 5 nc -zv $BACKEND_IP 5432 && echo "✗ Test-client→Backend FAIL" || echo "✓ Test-client→Backend blocked"
kubectl exec -n external-ns external-client -- timeout 5 nc -zv $BACKEND_IP 5432 && echo "✗ External→Backend FAIL" || echo "✓ External→Backend blocked"
kubectl exec -n netpol-lab backend -- timeout 5 nc -zv $FRONTEND_IP 80 && echo "✓ Backend→Frontend OK" || echo "✗ Backend→Frontend FAIL"
