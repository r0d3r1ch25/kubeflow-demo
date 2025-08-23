# Kubeflow Pipelines on k3d - Lightweight Local Setup with Monitoring

A minimal, production-ready Kubeflow Pipelines deployment running on k3d for local development and experimentation. Perfect for ML engineers who want to explore Kubeflow without the complexity of a full cluster setup.

## 🎯 What You Get

- **Kubeflow Pipelines** - Complete ML workflow orchestration
- **Jupyter Notebooks** - Interactive development environment  
- **MinIO** - S3-compatible artifact storage (latest 2024 release)
- **MySQL** - Pipeline metadata storage
- **Argo Workflows** - Robust pipeline execution engine
- **Monitoring Stack** - Promtail + Loki + Grafana for log aggregation and visualization

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
3. Deploy monitoring stack (Loki, Promtail, Grafana)
4. Wait for everything to be ready
5. Show you the access URLs

### Access Your Services

Once deployed, access these URLs in your browser (using NodePort services):

- **🔬 Kubeflow Pipelines UI**: http://localhost:31380
- **📊 MinIO Console**: http://localhost:31390 (user: `minio`, pass: `minio123`)
- **📓 Jupyter Notebook**: http://localhost:31400 (no password required)
- **📈 Grafana Dashboard**: http://localhost:31410 (user: `admin`, pass: `admin`)

> **Note**: Services are exposed via NodePort on your local machine. The k3d cluster automatically forwards these ports to localhost.

## 🏗️ Architecture

This setup provides a complete ML pipeline platform with integrated monitoring:

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Jupyter       │    │  Kubeflow       │    │     MinIO       │
│   Notebooks     │◄──►│   Pipelines     │◄──►│   Storage       │
│   :31400        │    │    :31380       │    │   :31390        │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐    ┌─────────────────┐
                    │     MySQL       │    │    Grafana      │
                    │   + ML Metadata │    │   + Loki Logs   │
                    └─────────────────┘    │    :31410       │
                                          └─────────────────┘
```

### Core Components

- **MySQL 8.0** - Pipeline metadata and experiment tracking
- **MinIO (2024 Release)** - Artifact storage with secret-based authentication
- **Argo Workflows** - Pipeline execution engine
- **ML Pipeline API 2.0** - REST API with v2beta1 support
- **ML Pipeline UI 2.0** - Web interface for pipeline visualization
- **Visualization Server** - Pipeline step visualizations
- **ML Metadata (MLMD)** - Execution tracking and lineage
- **Metadata Envoy** - Proxy for metadata services
- **Persistence Agent** - Workflow completion handling
- **Scheduled Workflow** - Recurring pipeline execution
- **Jupyter Notebook** - Development and experimentation

### Monitoring Components

- **Loki** - Log aggregation system for centralized logging
- **Promtail** - Log collection agent (DaemonSet) that scrapes Kubeflow pod logs
- **Grafana** - Dashboard and visualization with Loki datasource pre-configured

## 📋 Available Commands

```bash
# Deploy everything (Kubeflow + Monitoring)
make cluster-up

# Check component status (includes monitoring)
make status

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
5. **View logs** in Grafana at http://localhost:31410
6. **Iterate** and improve your ML workflows

## 📁 Project Structure

```
k8s/
├── base/
│   ├── namespace.yaml      # Kubeflow namespace
│   └── rbac.yaml          # Service accounts and permissions
├── storage/
│   ├── deployments/
│   │   ├── minio-deploy.yaml    # MinIO with secret references
│   │   └── mysql-deploy.yaml    # MySQL database
│   ├── services/
│   │   ├── minio-service.yaml   # MinIO services
│   │   └── mysql-service.yaml   # MySQL service
│   ├── minio-secret.yaml        # Centralized MinIO credentials
│   ├── minio.yaml              # Combined MinIO resources
│   └── mysql.yaml              # Combined MySQL resources
├── pipelines/
│   ├── deployments/
│   │   └── ml-pipeline-deploy.yaml      # Pipeline API server
│   ├── services/
│   │   └── ml-pipeline-service.yaml     # Pipeline services
│   ├── argo-workflow.yaml               # Workflow execution engine
│   ├── scheduledworkflow-crd.yaml       # Custom resource definitions
│   ├── ml-pipeline.yaml                 # Pipeline API server (v2.0)
│   ├── ml-pipeline-ui.yaml              # Web interface (v2.0)
│   ├── ml-pipeline-visualizationserver.yaml  # Visualization service
│   ├── metadata-envoy.yaml              # ML Metadata proxy
│   ├── metadata-grpc.yaml               # ML Metadata GRPC server
│   ├── ml-pipeline-persistenceagent.yaml     # Workflow completion
│   └── ml-pipeline-scheduledworkflow.yaml    # Recurring pipelines
├── notebooks/
│   └── jupyter.yaml       # Jupyter notebook server
├── monitoring/
│   ├── namespace.yaml     # Monitoring namespace
│   ├── loki/
│   │   ├── deployment.yaml    # Loki log aggregation
│   │   ├── service.yaml       # Loki service
│   │   └── kustomization.yaml
│   ├── promtail/
│   │   ├── configmap.yaml     # Promtail config for Kubeflow logs
│   │   ├── daemonset.yaml     # Promtail log collector
│   │   ├── rbac.yaml          # Promtail permissions
│   │   └── kustomization.yaml
│   ├── grafana/
│   │   ├── configmap.yaml     # Grafana datasource (Loki)
│   │   ├── deployment.yaml    # Grafana dashboard
│   │   ├── service.yaml       # Grafana NodePort (31410)
│   │   └── kustomization.yaml
│   └── kustomization.yaml     # Monitoring stack
└── kustomization.yaml     # Main Kustomize configuration
```

## 🔐 Security Features

- **Secret-based Authentication** - All MinIO credentials reference centralized secrets
- **RBAC** - Proper service accounts and role-based access control
- **Namespace Isolation** - Separate namespaces for Kubeflow and monitoring
- **No Hardcoded Passwords** - Credentials managed through Kubernetes secrets

To change MinIO passwords, update only the base64 values in `k8s/storage/minio-secret.yaml`.

## 💡 Use Cases

- **ML Experimentation** - Rapid prototyping of ML workflows
- **Pipeline Development** - Build and test Kubeflow pipelines locally
- **Log Analysis** - Monitor pipeline execution through centralized logging
- **Education** - Learn Kubeflow concepts without cloud complexity
- **CI/CD Testing** - Validate pipelines before production deployment
- **Resource Optimization** - Test pipeline resource requirements

## 🖥️ System Requirements

**Tested Environment:**
- macOS (Apple Silicon M-series recommended)
- 8GB+ RAM available for Docker
- 12GB+ free disk space

**Resource Usage:**
- ~3GB RAM for all components (including monitoring)
- ~8GB disk space for images and data
- Minimal CPU usage when idle

## 🔍 Troubleshooting

### Check Component Status
```bash
# All components
make status

# Kubeflow only
kubectl get pods -n kubeflow

# Monitoring only
kubectl get pods -n monitoring
```

### View Logs
```bash
# Pipeline API logs
kubectl logs -n kubeflow -l app=ml-pipeline

# UI logs  
kubectl logs -n kubeflow -l app=ml-pipeline-ui

# Grafana logs
kubectl logs -n monitoring -l app=grafana

# Loki logs
kubectl logs -n monitoring -l app=loki
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
- ✅ **Production patterns** - Real MySQL, proper RBAC, secret management
- ✅ **No Istio** - Simplified networking with NodePort access
- ✅ **Integrated Monitoring** - Built-in log aggregation and visualization
- ✅ **Security-focused** - Centralized credential management
- ✅ **Latest MinIO** - Recent 2024 release for better performance

## 🤝 Usage

Feel free to fork this repository or clone it for your own ML experiments.
This setup is designed to be easily customizable for different use cases.

## 📄 License

MIT License - feel free to use this for your projects.

---

*This setup gets you from zero to running ML pipelines with monitoring in under 10 minutes. Perfect for exploring Kubeflow capabilities without the operational overhead.*