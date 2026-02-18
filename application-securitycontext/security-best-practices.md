# Kubernetes SecurityContext Best Practices

## Essential Security Settings

1. **Always run as non-root**
   - Set `runAsNonRoot: true`
   - Specify explicit `runAsUser` and `runAsGroup`

2. **Use read-only root filesystem**
   - Set `readOnlyRootFilesystem: true`
   - Mount writable volumes for application data

3. **Drop all capabilities by default**
   - Use `capabilities.drop: [ALL]`
   - Only add specific capabilities when needed

4. **Disable privilege escalation**
   - Set `allowPrivilegeEscalation: false`

5. **Use security profiles**
   - Enable seccomp: `seccompProfile.type: RuntimeDefault`
   - Consider AppArmor or SELinux profiles

## Common Pitfalls to Avoid

- Running containers as root (UID 0)
- Allowing writable root filesystem
- Granting unnecessary Linux capabilities
- Not setting explicit user/group IDs
- Ignoring Pod Security Standards

## Validation Checklist

- [ ] Non-root user configured
- [ ] Read-only root filesystem enabled
- [ ] All capabilities dropped (unless specifically needed)
- [ ] Privilege escalation disabled
- [ ] Security profiles configured
- [ ] Writable volumes mounted only where needed
