# API Version Changes Summary

## Deployment Changes
- **Old**: `extensions/v1beta1` (deprecated in 1.9, removed in 1.16)
- **New**: `apps/v1` (stable since 1.9)
- **Key Changes**: No significant changes in structure

## Ingress Changes
- **Old**: `extensions/v1beta1` (deprecated in 1.14, removed in 1.22)
- **New**: `networking.k8s.io/v1` (stable since 1.19)
- **Key Changes**: 
  - `backend.serviceName` → `backend.service.name`
  - `backend.servicePort` → `backend.service.port.number`
  - Added required `pathType` field

## PodSecurityPolicy Changes
- **Old**: `policy/v1beta1` (deprecated in 1.21, removed in 1.25)
- **New**: Pod Security Standards (built-in admission controller)
- **Key Changes**: 
  - No longer uses custom resources
  - Applied via namespace labels
  - Three levels: privileged, baseline, restricted
