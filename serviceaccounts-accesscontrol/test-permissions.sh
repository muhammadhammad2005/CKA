#!/bin/bash

echo "=== RBAC Permission Validation ==="
echo ""

check_permission() {
  ACTION=$1
  EXPECTED=$2
  RESULT=$3

  if [ "$RESULT" == "$EXPECTED" ]; then
    echo "✔ PASS: $ACTION -> $RESULT"
  else
    echo "✖ FAIL: $ACTION -> Expected: $EXPECTED, Got: $RESULT"
  fi
}

echo "=== Testing webapp-service-account ==="

WEBAPP_SA="system:serviceaccount:default:webapp-service-account"

res=$(kubectl auth can-i get pods --as=$WEBAPP_SA)
check_permission "webapp can get pods" "yes" "$res"

res=$(kubectl auth can-i list services --as=$WEBAPP_SA)
check_permission "webapp can list services" "yes" "$res"

res=$(kubectl auth can-i get secrets --as=$WEBAPP_SA)
check_permission "webapp can get secrets" "no" "$res"

res=$(kubectl auth can-i create pods --as=$WEBAPP_SA)
check_permission "webapp can create pods" "no" "$res"

echo ""
echo "=== Testing database-service-account ==="

DB_SA="system:serviceaccount:default:database-service-account"

res=$(kubectl auth can-i get secrets --as=$DB_SA)
check_permission "database can get secrets" "yes" "$res"

res=$(kubectl auth can-i get pods --as=$DB_SA)
check_permission "database can get pods" "no" "$res"

res=$(kubectl auth can-i create pods --as=$DB_SA)
check_permission "database can create pods" "no" "$res"

res=$(kubectl auth can-i get services --as=$DB_SA)
check_permission "database can get services" "no" "$res"

echo ""
echo "=== RBAC Testing Complete ==="
