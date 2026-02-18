# API Migration Checklist

## Pre-Migration Assessment
- [ ] Identify all manifests using deprecated APIs
- [ ] Check Kubernetes cluster version compatibility
- [ ] Review breaking changes in API documentation
- [ ] Test migrations in development environment
- [ ] Backup existing configurations

## Migration Process
- [ ] Update API versions in manifest files
- [ ] Modify field names and structure as required
- [ ] Validate updated manifests with dry-run
- [ ] Test functionality in staging environment
- [ ] Plan rollback strategy

## Post-Migration Verification
- [ ] Verify all resources are running correctly
- [ ] Check application functionality
- [ ] Monitor for any errors or warnings
- [ ] Update documentation and runbooks
- [ ] Schedule regular API deprecation checks

## Common API Migrations

### Deployment (extensions/v1beta1 → apps/v1)
- No structural changes required
- Simply update apiVersion field

### Ingress (extensions/v1beta1 → networking.k8s.io/v1)
- Update backend field structure
- Add pathType field (required)
- Update serviceName/servicePort to service.name/service.port

### PodSecurityPolicy (policy/v1beta1 → Pod Security Standards)
- Replace PSP resources with namespace labels
- Use pod-security.kubernetes.io/* labels
- Choose appropriate security level (privileged/baseline/restricted)
