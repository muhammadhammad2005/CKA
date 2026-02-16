# Kubernetes Debugging Methods Comparison

## kubectl exec
- Use Case: Quick container inspection
- Pros: Simple
- Cons: Limited tools
- Best For: Basic troubleshooting

## Ephemeral Containers
- Use Case: Advanced debugging
- Pros: Full toolkit, non-intrusive
- Cons: Kubernetes 1.18+, more setup
- Best For: Production debugging

## kubectl logs
- Use Case: Check logs
- Pros: Non-intrusive
- Cons: Limited to logs
- Best For: Initial investigation

## kubectl describe
- Use Case: Configuration and events
- Pros: Shows config issues and events
- Cons: No runtime info
- Best For: Scheduling/config issues
