#!/bin/bash

echo "RBAC Audit Report"
echo "=================="
echo "Date: $(date)"
echo ""

echo "ServiceAccounts in default namespace:"
kubectl get serviceaccounts -o custom-columns=NAME:.metadata.name,SECRETS:.secrets[*].name

echo ""
echo "Roles and their permissions:"
for role in $(kubectl get roles -o jsonpath='{.items[*].metadata.name}'); do
    echo "Role: $role"
    kubectl describe role $role | grep -A 20 "Rules:"
    echo "---"
done

echo ""
echo "RoleBindings:"
kubectl get rolebindings -o custom-columns=NAME:.metadata.name,ROLE:.roleRef.name,SUBJECTS:.subjects[*].name
