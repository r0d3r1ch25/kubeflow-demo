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

Install the Python dependencies used by the example pipeline:

```bash
pip install -r requirements.txt
```

### Submit the sample pipeline

After port-forwarding is running, you can upload and execute the example pipeline with:

```bash
python run_pipeline.py
```

The script uses the Kubeflow Pipelines API on `localhost:8888` to create a run from
`test_pipeline.yaml`.

## Access URLs

After running `make forward`:

- **Kubeflow Pipelines UI**: http://localhost:8080
- **Jupyter Notebook**: http://localhost:8889 (token required - use `make token`)
- **Kubeflow Pipelines API**: http://localhost:8888 (REST) / http://localhost:8887 (gRPC)
- **MinIO S3 API**: http://localhost:9000
- **MinIO Console**: http://localhost:9001 (user: minio, pass: minio123)
- **Grafana Dashboard**: http://localhost:3001 (user: admin, pass: admin)

## Architecture

- **Single-node cluster**: All components run on one k3d node (control plane + worker)
- **ClusterIP services**: Using port-forwarding instead of NodePort
- **Persistent storage**: Host path volumes in `/opt/k8s_data/kf-cluster/`
- **Namespaces**: `kubeflow` for ML components, `monitoring` for observability

## Persistent Data

Data is stored locally in the `data/` directory created at cluster startup:
- Jupyter notebooks: `data/notebooks/`
- MinIO data: `data/minio/`
- MySQL data: `data/mysql/`

## Development Notes

This setup is for local development and testing only. Components are configured for ease of use rather than production security or performance.

## Cleanup

```bash
# Stop port-forwarding
make stop-forward

# Delete cluster
make cluster-down
```