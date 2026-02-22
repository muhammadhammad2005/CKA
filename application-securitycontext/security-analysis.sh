#!/bin/bash

set -e

echo "=== Kubernetes Security Analysis Report ==="
echo

# Dependency check
if ! command -v kubectl &>/dev/null; then
  echo "ERROR: kubectl not found"
  exit 1
fi

# Get all pods dynamically
pods=$(kubectl get pods -o jsonpath='{.items[*].metadata.name}')

if [ -z "$pods" ]; then
  echo "No pods found in current namespace"
  exit 0
fi

for pod in $pods; do
    echo "🔍 Pod: $pod"

    # Check if pod is running
    status=$(kubectl get pod $pod -o jsonpath='{.status.phase}')
    echo "Status: $status"

    # Extract security context (non-intrusive)
    runAsUser=$(kubectl get pod $pod -o jsonpath='{.spec.securityContext.runAsUser}' 2>/dev/null || echo "N/A")
    runAsNonRoot=$(kubectl get pod $pod -o jsonpath='{.spec.securityContext.runAsNonRoot}' 2>/dev/null || echo "N/A")
    fsGroup=$(kubectl get pod $pod -o jsonpath='{.spec.securityContext.fsGroup}' 2>/dev/null || echo "N/A")

    echo "runAsUser: ${runAsUser:-N/A}"
    echo "runAsNonRoot: ${runAsNonRoot:-N/A}"
    echo "fsGroup: ${fsGroup:-N/A}"

    # Container-level checks
    echo "Containers:"
    kubectl get pod $pod -o json | jq -r '
    .spec.containers[] |
    "  - Name: \(.name)\n    allowPrivilegeEscalation: \(.securityContext.allowPrivilegeEscalation // "N/A")\n    readOnlyRootFilesystem: \(.securityContext.readOnlyRootFilesystem // "N/A")\n    privileged: \(.securityContext.privileged // "N/A")"
    '

    echo "----------------------------------------"
done

echo
echo "✅ Analysis Complete"
