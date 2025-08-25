# Kubeflow Demo - Local Development Setup

**⚠️ Work in Progress - Not production ready**

This is a local development setup for Kubeflow Pipelines with Jupyter notebooks. Currently being developed and tested.

## Current Status

### Working Components
- ✅ Single-node k3d cluster
- ✅ MySQL database (with warnings, but functional)
- ✅ MinIO object storage
- ✅ Jupyter notebooks with persistent storage
- ✅ Kubeflow Pipelines API
- ✅ Pipeline UI
- ✅ Port-forwarding for local access
- ✅ Grafana monitoring

### Known Issues
- 🔧 MySQL shows deprecation warnings (functional but noisy)
- 🔧 Pipeline creation may have intermittent proxy issues
- 🔧 Some components still stabilizing

## Quick Start

```bash
# Create cluster and deploy everything
make cluster-up

# Check status (wait for all pods to be ready)
make status

# Start port-forwarding for local access
make forward
```

## Access URLs

After running `make forward`:

- **Kubeflow Pipelines UI**: http://localhost:8080
- **Jupyter Notebook**: http://localhost:8888 (no token required)
- **MinIO Console**: http://localhost:9001 (user: minio, pass: minio123)
- **Grafana Dashboard**: http://localhost:3001 (user: admin, pass: admin)

## Architecture

- **Single-node cluster**: All components run on one k3d node (control plane + worker)
- **ClusterIP services**: Using port-forwarding instead of NodePort
- **Persistent storage**: Host path volumes in `/opt/k8s_data/kf-cluster/`
- **Namespaces**: `kubeflow` for ML components, `monitoring` for observability

## Persistent Data

Data is stored locally in:
- Jupyter notebooks: `/opt/k8s_data/kf-cluster/notebooks/`
- MinIO data: `/opt/k8s_data/kf-cluster/minio/`
- MySQL data: `/opt/k8s_data/kf-cluster/mysql/`

## Development Notes

This setup is for local development and testing only. Components are configured for ease of use rather than production security or performance.

## Cleanup

```bash
# Stop port-forwarding
make stop-forward

# Delete cluster
make cluster-down
```