# Kubeflow Demo

Minimal Kubeflow setup for local development on Mac using k3d.

## Prerequisites

- Docker Desktop
- k3d: `brew install k3d`
- kubectl: `brew install kubectl`

## Quick Start

```bash
# Create k3d cluster
make cluster

# Deploy notebook server
make notebooks

# Check pods status
make pods

# Access notebook (once pod is running)
make port-forward
```

Open http://localhost:8080 in your browser.

## Cleanup

```bash
make delete
```

## Repository Structure

- `k8s/cluster/` - Cluster configuration
- `k8s/notebooks/` - Notebook CRDs
- `k8s/manifests/` - Future Kubeflow manifests