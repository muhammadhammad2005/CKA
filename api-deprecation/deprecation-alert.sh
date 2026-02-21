#!/bin/bash

set -e

# Configuration
ALERT_FILE="/tmp/k8s-deprecation-alerts.log"
EMAIL_ALERT=false

# Dependency check
for cmd in kubectl jq; do
  if ! command -v $cmd &>/dev/null; then
    echo "ERROR: $cmd is not installed"
    exit 1
  fi
done

# Function to log alerts
log_alert() {
    local message="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] ALERT: $message" | tee -a "$ALERT_FILE"
}

# Function to check deprecated APIs
check_deprecated_apis() {
    echo "🔍 Scanning for deprecated APIs..."

    found_issues=0

    # Check deprecated Deployments APIs
    for api in extensions/v1beta1 apps/v1beta1 apps/v1beta2; do
        results=$(kubectl get deployments --all-namespaces -o json | \
        jq -r ".items[] | select(.apiVersion == \"$api\") | \"\(.metadata.namespace)/\(.metadata.name)\"")

        if [ -n "$results" ]; then
            log_alert "Deployments using $api: $results"
            found_issues=1
        fi
    done

    # Check deprecated Ingress APIs
    results=$(kubectl get ingresses --all-namespaces -o json | \
    jq -r '.items[] | select(.apiVersion == "extensions/v1beta1" or .apiVersion == "networking.k8s.io/v1beta1") | "\(.metadata.namespace)/\(.metadata.name)"')

    if [ -n "$results" ]; then
        log_alert "Ingress resources using deprecated APIs: $results"
        found_issues=1
    fi

    # Check PodSecurityPolicy
    if kubectl get psp &>/dev/null; then
        count=$(kubectl get psp --no-headers 2>/dev/null | wc -l)
        if [ "$count" -gt 0 ]; then
            log_alert "Found $count PodSecurityPolicy resources (removed in Kubernetes 1.25)"
            found_issues=1
        fi
    fi

    return $found_issues
}

# Main execution
echo "🚀 Starting Kubernetes API deprecation scan at $(date)"
echo "--------------------------------------------"

check_deprecated_apis

RESULT=$?

echo "--------------------------------------------"

if [ $RESULT -ne 0 ]; then
    echo "⚠️ Deprecated APIs detected. Review $ALERT_FILE"
    exit 1
else
    echo "✅ No deprecated APIs found. Cluster is compliant."
    exit 0
fi
