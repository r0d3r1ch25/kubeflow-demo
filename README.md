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

# Install Kubeflow components
make kubeflow

# Deploy notebook server
make notebooks

# Check pods status
make pods

# Access notebook (once pod is running)
make port-forward
```

Open http://localhost:8080 in your browser.

## How It Works

This minimal Kubeflow setup includes:

1. **Notebook CRD** - Defines the `Notebook` custom resource
2. **Notebook Controller** - Manages notebook pods automatically
3. **Notebook Instance** - Your actual Python notebook

The controller watches for `Notebook` resources and creates the underlying pods, services, and volumes automatically.

## Cleanup

```bash
make delete
```

## Repository Structure

- `k8s/manifests/` - Kubeflow CRDs and controllers
- `k8s/notebooks/` - Notebook instances