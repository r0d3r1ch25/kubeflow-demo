# Kubeflow Pipelines on k3d - Lightweight Local Setup

A minimal, production-ready Kubeflow Pipelines deployment running on k3d for local development and experimentation. Perfect for ML engineers who want to explore Kubeflow without the complexity of a full cluster setup.

## 🎯 What You Get

- **Kubeflow Pipelines** - Complete ML workflow orchestration
- **Jupyter Notebooks** - Interactive development environment  
- **MinIO** - S3-compatible artifact storage
- **MySQL** - Pipeline metadata storage
- **Argo Workflows** - Robust pipeline execution engine

All running locally with minimal resource usage, tested on Apple Silicon (M-series) Macs.

## 🚀 Quick Start

### Prerequisites

```bash
# Install required tools (macOS)
brew install make kubectl k3d
```

### One-Command Deploy

```bash
make cluster-up
```

That's it! The command will:
1. Create a k3d cluster with proper port forwarding
2. Deploy all Kubeflow components
3. Wait for everything to be ready
4. Show you the access URLs

### Access Your Services

Once deployed, access these URLs in your browser (using NodePort services):

- **🔬 Kubeflow Pipelines UI**: http://localhost:31380
- **📊 MinIO Console**: http://localhost:31390 (user: `minio`, pass: `minio123`)
- **📓 Jupyter Notebook**: http://localhost:31400 (no password required)

> **Note**: Services are exposed via NodePort on your local machine. The k3d cluster automatically forwards these ports to localhost.

## 🏗️ Architecture

This setup provides a complete ML pipeline platform with:

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Jupyter       │    │  Kubeflow       │    │     MinIO       │
│   Notebooks     │◄──►│   Pipelines     │◄──►│   Storage       │
│   :31400        │    │    :31380       │    │   :31390        │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │     MySQL       │
                    │   Metadata      │
                    └─────────────────┘
```

### Components

- **MySQL 8.0** - Pipeline metadata and experiment tracking
- **MinIO** - Artifact storage (models, datasets, outputs)
- **Argo Workflows** - Pipeline execution engine
- **ML Pipeline API 2.0** - REST API with v2beta1 support
- **ML Pipeline UI 2.0** - Web interface for pipeline visualization
- **Visualization Server** - Pipeline step visualizations
- **ML Metadata (MLMD)** - Execution tracking and lineage
- **Metadata Envoy** - Proxy for metadata services
- **Persistence Agent** - Workflow completion handling
- **Scheduled Workflow** - Recurring pipeline execution
- **Jupyter Notebook** - Development and experimentation

## 📋 Available Commands

```bash
# Deploy everything
make cluster-up

# Check component status
make status

# Deploy to existing cluster
make deploy

# Remove components (keep cluster)
make undeploy

# Delete entire cluster
make cluster-down

# Get Jupyter token (if needed)
make token
```

## 🔧 Development Workflow

1. **Develop** in Jupyter Notebooks at http://localhost:31400
2. **Create** ML pipelines using the Kubeflow Pipelines SDK
3. **Upload** and run pipelines via the UI at http://localhost:31380
4. **Monitor** execution and view artifacts
5. **Iterate** and improve your ML workflows

## 📁 Project Structure

```
k8s/
├── base/
│   ├── namespace.yaml      # Kubeflow namespace
│   └── rbac.yaml          # Service accounts and permissions
├── storage/
│   ├── minio.yaml         # S3-compatible object storage
│   └── mysql.yaml         # Pipeline metadata database
├── pipelines/
│   ├── argo-workflow.yaml           # Workflow execution engine
│   ├── scheduledworkflow-crd.yaml   # Custom resource definitions
│   ├── ml-pipeline.yaml             # Pipeline API server (v2.0)
│   ├── ml-pipeline-ui.yaml          # Web interface (v2.0)
│   ├── ml-pipeline-visualizationserver.yaml  # Visualization service
│   ├── metadata-envoy.yaml          # ML Metadata proxy
│   ├── metadata-grpc.yaml           # ML Metadata GRPC server
│   ├── ml-pipeline-persistenceagent.yaml     # Workflow completion
│   └── ml-pipeline-scheduledworkflow.yaml    # Recurring pipelines
├── notebooks/
│   └── jupyter.yaml       # Jupyter notebook server
└── kustomization.yaml     # Kustomize configuration
```

## 💡 Use Cases

- **ML Experimentation** - Rapid prototyping of ML workflows
- **Pipeline Development** - Build and test Kubeflow pipelines locally
- **Education** - Learn Kubeflow concepts without cloud complexity
- **CI/CD Testing** - Validate pipelines before production deployment
- **Resource Optimization** - Test pipeline resource requirements

## 🖥️ System Requirements

**Tested Environment:**
- macOS (Apple Silicon M-series recommended)
- 8GB+ RAM available for Docker
- 10GB+ free disk space

**Resource Usage:**
- ~2GB RAM for all components
- ~5GB disk space for images and data
- Minimal CPU usage when idle

## 🔍 Troubleshooting

### Check Component Status
```bash
kubectl get pods -n kubeflow
```

### View Logs
```bash
# Pipeline API logs
kubectl logs -n kubeflow -l app=ml-pipeline

# UI logs  
kubectl logs -n kubeflow -l app=ml-pipeline-ui

# All component logs
kubectl logs -n kubeflow --all-containers=true
```

### Reset Everything
```bash
make cluster-down
make cluster-up
```

## 🚦 What's Different

Unlike heavy Kubeflow distributions, this setup:

- ✅ **Lightweight** - Only essential components
- ✅ **Fast startup** - Ready in minutes, not hours
- ✅ **Local-first** - No cloud dependencies
- ✅ **Apple Silicon** - Optimized for M-series Macs
- ✅ **Modular** - Easy to understand and modify
- ✅ **Production patterns** - Real MySQL, proper RBAC
- ✅ **No Istio** - Simplified networking with NodePort access
- ✅ **Init containers** - Proper startup dependencies

## 🤝 Usage

Feel free to fork this repository or clone it for your own ML experiments.
This setup is designed to be easily customizable for different use cases.

## 📄 License

MIT License - feel free to use this for your projects.

---

*This setup gets you from zero to running ML pipelines in under 10 minutes. Perfect for exploring Kubeflow capabilities without the operational overhead.*