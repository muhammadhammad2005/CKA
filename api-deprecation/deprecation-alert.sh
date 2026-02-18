#!/bin/bash

# Configuration
ALERT_FILE="/tmp/k8s-deprecation-alerts.log"
EMAIL_ALERT=false  # Set to true if you want email alerts

# Function to log alerts
log_alert() {
    local message="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] ALERT: $message" | tee -a "$ALERT_FILE"
}

# Check for deprecated APIs in use
check_deprecated_apis() {
    echo "Scanning for deprecated APIs..."
    
    # Check for extensions/v1beta1 deployments
    deprecated_deployments=$(kubectl get deployments --all-namespaces -o json 2>/dev/null | jq -r '.items[] | select(.apiVersion == "extensions/v1beta1") | "\(.metadata.namespace)/\(.metadata.name)"' 2>/dev/null)
    
    if [ ! -z "$deprecated_deployments" ]; then
        log_alert "Found deployments using deprecated extensions/v1beta1 API: $deprecated_deployments"
    fi
    
    # Check for extensions/v1beta1 ingresses
    deprecated_ingresses=$(kubectl get ingresses --all-namespaces -o json 2>/dev/null | jq -r '.items[] | select(.apiVersion == "extensions/v1beta1") | "\(.metadata.namespace)/\(.metadata.name)"' 2>/dev/null)
    
    if [ ! -z "$deprecated_ingresses" ]; then
        log_alert "Found ingresses using deprecated extensions/v1beta1 API: $deprecated_ingresses"
    fi
    
    # Check for PodSecurityPolicies
    deprecated_psp=$(kubectl get psp 2>/dev/null | tail -n +2 | wc -l)
    
    if [ "$deprecated_psp" -gt 0 ]; then
        log_alert "Found $deprecated_psp PodSecurityPolicy resources (deprecated in 1.21, removed in 1.25)"
    fi
}

# Main execution
echo "Starting deprecation check at $(date)"
check_deprecated_apis

if [ -f "$ALERT_FILE" ] && [ -s "$ALERT_FILE" ]; then
    echo "Alerts generated. Check $ALERT_FILE for details."
    if [ "$EMAIL_ALERT" = true ]; then
        echo "Email alerts would be sent here (configure your email system)"
    fi
else
    echo "No deprecated APIs found. Cluster is up to date!"
fi
