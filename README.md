# Kubeflow Pipelines on k3d - Lightweight Local Setup with Monitoring

A minimal, production-ready Kubeflow Pipelines deployment running on k3d for local development and experimentation. Perfect for ML engineers who want to explore Kubeflow without the complexity of a full cluster setup.

## 🎯 What You Get

- **Kubeflow Pipelines** - Complete ML workflow orchestration
- **Jupyter Notebooks** - Interactive development environment  
- **MinIO** - S3-compatible artifact storage
- **MySQL** - Pipeline metadata storage
- **Argo Workflows** - Robust pipeline execution engine
- **Monitoring Stack** - Promtail + Loki + Grafana for log aggregation and visualization

All running locally with minimal resource usage, tested on Apple Silicon (M-series) Macs.

## 🚀 Quick Start

### Prerequisites

```bash
# Install required tools (macOS)
brew install make kubectl k3d kustomize
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
- **MinIO ** - Artifact storage with secret-based authentication
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

**Perfect Kubernetes Modular Architecture - One Kind Per File**

```
k8s/
├── base/                            # Core Kubeflow foundation
│   ├── rbac/                        # RBAC resources (one per file)
│   │   ├── pipeline-runner-serviceaccount.yaml
│   │   ├── pipeline-runner-clusterrole.yaml
│   │   └── pipeline-runner-clusterrolebinding.yaml
│   ├── kustomization.yaml           # Base module configuration
│   └── namespace.yaml               # Kubeflow namespace
├── storage/                         # Data persistence layer
│   ├── deployments/                 # All deployment resources
│   │   ├── minio-deploy.yaml        # MinIO object storage
│   │   └── mysql-deploy.yaml        # MySQL metadata database
│   ├── services/                    # All service resources
│   │   ├── minio-service.yaml       # MinIO API service
│   │   ├── minio-console-service.yaml # MinIO console (NodePort 31390)
│   │   └── mysql-service.yaml       # MySQL service
│   ├── secrets/                     # All secret resources
│   │   └── minio-secret.yaml        # Centralized MinIO credentials
│   └── kustomization.yaml           # Storage module configuration
├── pipelines/                       # ML Pipeline orchestration
│   ├── crds/                        # Custom Resource Definitions
│   │   ├── workflows-crd.yaml       # Argo Workflows CRD
│   │   └── scheduledworkflow-crd.yaml # Scheduled Workflow CRD
│   ├── configmaps/                  # All ConfigMap resources
│   │   └── workflow-controller-configmap.yaml
│   ├── deployments/                 # All deployment resources
│   │   ├── ml-pipeline-deploy.yaml  # Pipeline API server
│   │   ├── ml-pipeline-ui-deployment.yaml # Web interface
│   │   ├── ml-pipeline-visualizationserver-deployment.yaml
│   │   ├── ml-pipeline-persistenceagent-deployment.yaml
│   │   ├── ml-pipeline-scheduledworkflow-deployment.yaml
│   │   ├── metadata-grpc-deployment.yaml # ML Metadata GRPC
│   │   ├── metadata-envoy-deployment.yaml # ML Metadata proxy
│   │   └── workflow-controller-deployment.yaml # Argo controller
│   ├── services/                    # All service resources
│   │   ├── ml-pipeline-service.yaml # Pipeline API service
│   │   ├── ml-pipeline-ui-service.yaml # UI service (NodePort 31380)
│   │   ├── ml-pipeline-visualizationserver-service.yaml
│   │   ├── metadata-grpc-service.yaml
│   │   └── metadata-envoy-service.yaml
│   └── kustomization.yaml           # Pipelines module configuration
├── notebooks/                       # Interactive development environment
│   ├── deployments/                 # All deployment resources
│   │   └── jupyter-deployment.yaml  # Jupyter notebook server
│   ├── services/                    # All service resources
│   │   └── jupyter-service.yaml     # Jupyter service (NodePort 31400)
│   └── kustomization.yaml           # Notebooks module configuration
├── monitoring/                      # Observability and logging stack
│   ├── deployments/                 # All deployment resources
│   │   ├── loki-deployment.yaml     # Log aggregation system
│   │   └── grafana-deployment.yaml  # Dashboard and visualization
│   ├── services/                    # All service resources
│   │   ├── loki-service.yaml        # Loki service
│   │   └── grafana-service.yaml     # Grafana service (NodePort 31410)
│   ├── configmaps/                  # All ConfigMap resources
│   │   ├── grafana-configmap.yaml   # Grafana datasource (Loki)
│   │   └── promtail-configmap.yaml  # Promtail config for Kubeflow logs
│   ├── daemonsets/                  # All DaemonSet resources
│   │   └── promtail-daemonset.yaml  # Log collection agent
│   ├── rbac/                        # RBAC resources (one per file)
│   │   ├── promtail-serviceaccount.yaml
│   │   ├── promtail-clusterrole.yaml
│   │   └── promtail-clusterrolebinding.yaml
│   ├── namespace.yaml               # Monitoring namespace
│   └── kustomization.yaml           # Monitoring module configuration
└── kustomization.yaml               # Main modular configuration
```

## 🔐 Security Features

- **Secret-based Authentication** - All MinIO credentials reference centralized secrets
- **RBAC** - Proper service accounts and role-based access control
- **Namespace Isolation** - Separate namespaces for Kubeflow and monitoring
- **No Hardcoded Passwords** - Credentials managed through Kubernetes secrets


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
- ✅ **Modular** - Professional Kubernetes structure with proper separation of concerns
- ✅ **Production patterns** - Real MySQL, proper RBAC, secret management
- ✅ **No Istio** - Simplified networking with NodePort access
- ✅ **Integrated Monitoring** - Built-in log aggregation and visualization
- ✅ **Security-focused** - Centralized credential management
- ✅ **Latest MinIO** - Recent 2024 release for better performance
- ✅ **No Duplicates** - Single deployment per service, optimized resource usage
- ✅ **Perfect Kubernetes Structure** - One Kind per YAML file, properly organized by resource type
- ✅ **Zero Mixed Files** - Each YAML contains exactly one Kubernetes resource
- ✅ **Enterprise-Ready** - Follows GitOps and Kubernetes best practices for production

## 🤝 Usage

Feel free to fork this repository or clone it for your own ML experiments.
This setup is designed to be easily customizable for different use cases.

## 📄 License

MIT License - feel free to use this for your projects.

---

*This setup gets you from zero to running ML pipelines with monitoring in under 10 minutes. Perfect for exploring Kubeflow capabilities without the operational overhead.*