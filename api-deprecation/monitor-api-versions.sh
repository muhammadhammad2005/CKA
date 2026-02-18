#!/bin/bash

echo "=== Kubernetes API Version Monitor ==="
echo "Cluster Version: $(kubectl version --short --client)"
echo "Server Version: $(kubectl version --short --output=json | jq -r '.serverVersion.gitVersion')"
echo ""

# Function to check for deprecated APIs in running resources
check_running_resources() {
    echo "Checking running resources for deprecated APIs..."
    
    # Check deployments
    echo "Deployments using extensions/v1beta1:"
    kubectl get deployments --all-namespaces -o json | jq -r '.items[] | select(.apiVersion == "extensions/v1beta1") | "\(.metadata.namespace)/\(.metadata.name)"' 2>/dev/null || echo "None found"
    
    # Check ingresses
    echo "Ingresses using extensions/v1beta1:"
    kubectl get ingresses --all-namespaces -o json | jq -r '.items[] | select(.apiVersion == "extensions/v1beta1") | "\(.metadata.namespace)/\(.metadata.name)"' 2>/dev/null || echo "None found"
    
    echo ""
}

# Function to check API server capabilities
check_api_capabilities() {
    echo "Available API versions:"
    kubectl api-versions | grep -E "(apps|networking|policy)" | sort
    echo ""
    
    echo "Deprecated APIs still available:"
    kubectl api-versions | grep -E "(extensions/v1beta1|policy/v1beta1)" || echo "None found (good!)"
    echo ""
}

check_running_resources
check_api_capabilities

echo "=== Monitor Complete ==="
