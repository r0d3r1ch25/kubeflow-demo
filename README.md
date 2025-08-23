# Kubeflow Demo

This repository provides a minimal setup for running Kubeflow on a local k3d cluster with SQLite backend for learning purposes.

## Prerequisites

Before you begin, ensure you have the following tools installed:

*   [make](https://www.gnu.org/software/make/)
*   [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
*   [k3d](https://k3d.io/v5.6.0/#installation)

## Quick Start

1.  **Create cluster and deploy Kubeflow:**

    ```bash
    make cluster-up
    ```
    This command creates a k3d cluster and automatically deploys all Kubeflow components.

2.  **Check status:**

    ```bash
    make status
    ```

## Usage

Once the installation is complete, you can access the following services:

*   **Kubeflow Pipeline UI:** [http://localhost:31380](http://localhost:31380)
*   **MinIO Console:** [http://localhost:31390](http://localhost:31390) (user: `minio`, pass: `minio123`)
*   **Jupyter Notebook:** [http://localhost:31400](http://localhost:31400) (no password required)

## Architecture

The setup includes:

- **SQLite Database**: Lightweight database for pipeline metadata (no MySQL complexity)
- **MinIO**: S3-compatible object storage for artifacts
- **Argo Workflows**: Pipeline execution engine
- **Kubeflow Pipelines**: ML pipeline management
- **Jupyter Notebook**: Development environment

## Directory Structure

```
k8s/
├── base/
│   ├── namespace.yaml      # Kubeflow namespace
│   └── rbac.yaml          # Service accounts and permissions
├── storage/
│   └── minio.yaml         # MinIO object storage
├── pipelines/
│   ├── argo-workflow.yaml # Argo workflow controller
│   ├── ml-pipeline.yaml   # Pipeline API server
│   └── ml-pipeline-ui.yaml # Pipeline UI
├── notebooks/
│   └── jupyter.yaml       # Jupyter notebook server
└── kustomization.yaml     # Kustomize configuration
```

## Available Commands

- `make cluster-up` - Create cluster and deploy everything
- `make cluster-down` - Delete the entire cluster
- `make deploy` - Deploy components to existing cluster
- `make undeploy` - Remove components but keep cluster
- `make status` - Check component status
- `make token` - Get Jupyter notebook token (if needed)

## Cleanup

To delete the k3d cluster:

```bash
make cluster-down
```

## Features

- ✅ SQLite backend (no database complexity)
- ✅ Minimal resource usage
- ✅ All components in single namespace
- ✅ External access via NodePorts
- ✅ Modular Kubernetes manifests
- ✅ Simple deployment with make commands
- ✅ No Istio complexity
- ✅ Perfect for learning Kubeflow Pipelines