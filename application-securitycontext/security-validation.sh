#!/bin/bash

POD_NAME=$1

if [ -z "$POD_NAME" ]; then
    echo "Usage: $0 <pod-name>"
    exit 1
fi

echo "=== Security Validation for Pod: $POD_NAME ==="
echo

# Check if pod exists
if ! kubectl get pod $POD_NAME &>/dev/null; then
    echo "❌ Pod $POD_NAME not found"
    exit 1
fi

# Check if running as non-root
USER_ID=$(kubectl exec $POD_NAME -- id -u 2>/dev/null)
if [ "$USER_ID" = "0" ]; then
    echo "❌ Running as root user (UID: $USER_ID)"
else
    echo "✅ Running as non-root user (UID: $USER_ID)"
fi

# Check read-only root filesystem
if kubectl exec $POD_NAME -- touch /test-readonly 2>/dev/null; then
    kubectl exec $POD_NAME -- rm -f /test-readonly 2>/dev/null
    echo "❌ Root filesystem is writable"
else
    echo "✅ Root filesystem is read-only"
fi

# Check capabilities
CAPS=$(kubectl exec $POD_NAME -- cat /proc/1/status 2>/dev/null | grep CapEff | awk '{print $2}')
if [ "$CAPS" = "0000000000000000" ]; then
    echo "✅ All capabilities dropped"
else
    echo "⚠️  Some capabilities present: $CAPS"
fi

# Check privilege escalation
YAML=$(kubectl get pod $POD_NAME -o yaml)
if echo "$YAML" | grep -q "allowPrivilegeEscalation: false"; then
    echo "✅ Privilege escalation disabled"
else
    echo "❌ Privilege escalation not explicitly disabled"
fi

echo
echo "=== Validation Complete ==="
