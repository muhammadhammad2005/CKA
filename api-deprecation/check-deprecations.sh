#!/bin/bash

echo "=== API Deprecation Analysis ==="
echo "Checking manifests for deprecated APIs..."

# Function to check individual files
check_file() {
    local file=$1
    echo "Analyzing: $file"
    
    # Extract API versions from the file
    grep -n "apiVersion:" "$file" | while read -r line; do
        echo "  Found: $line"
        
        # Check if it's a known deprecated API
        if echo "$line" | grep -q "extensions/v1beta1"; then
            echo "  ⚠️  WARNING: extensions/v1beta1 is deprecated"
        fi
        
        if echo "$line" | grep -q "policy/v1beta1"; then
            echo "  ⚠️  WARNING: policy/v1beta1 is deprecated"
        fi
    done
    echo ""
}

# Check all YAML files in current directory
for file in *.yaml; do
    if [ -f "$file" ]; then
        check_file "$file"
    fi
done

echo "=== Analysis Complete ==="
