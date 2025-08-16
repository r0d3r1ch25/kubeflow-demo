# Kubeflow Demo

Minimal Kubeflow setup for local development on Mac using k3d.

## Step-by-Step Tutorial

### Step 1: Create the Kubernetes Cluster
```bash
make cluster
```
This creates a k3d cluster named `kubeflow-demo` with port 8888:8888 exposed on 0.0.0.0 (accessible from any IP). Wait for it to complete.

### Step 2: Install Kubeflow Components
```bash
make kubeflow
```
This installs:
- Notebook Custom Resource Definition (CRD)
- Notebook Controller that manages notebook pods

### Step 3: Deploy Your Notebook
```bash
make notebooks
```
This creates:
- The `kubeflow` namespace
- A `Notebook` resource named `python-demo`

This command will wait for the notebook pod to be ready.

### Step 4: Access Your Notebook

1.  **Get the access token:**
    ```bash
    make token
    ```
    This will print the access token for the Jupyter notebook.

2.  **Access the notebook:**
    Open `http://localhost:8888` in your browser and enter the token.

The notebook is directly accessible on port 8888:8888 without port-forwarding.

## Development

This repository includes a `Makefile` with several useful targets for development:

- `make cluster`: Create the k3d cluster.
- `make delete`: Delete the k3d cluster.
- `make kubeflow`: Install the Kubeflow components.
- `make notebooks`: Deploy the notebook.
- `make pods`: List all pods in the `kubeflow` namespace.

- `make token`: Get the notebook access token.
- `make delete-notebook`: Delete the notebook.

## How Kubeflow Works

1. **Notebook CRD** - Defines what a `Notebook` resource looks like
2. **Notebook Controller** - Watches for `Notebook` resources and automatically creates pods, services, and volumes
3. **Your Notebook** - The controller creates a Jupyter pod from your `Notebook` resource

**Key Point**: You don't create pods directly. You create `Notebook` resources, and Kubeflow manages the infrastructure.

## Cleanup
```bash
make delete
```
This removes the entire k3d cluster.

## Troubleshooting

- If `make notebooks` times out, check the pod status with `make pods` and the controller logs.
- If notebook access fails, ensure the pod is `Running` first.
- If cluster creation fails, delete with `make delete` and retry.

This setup provides a lightweight Kubeflow environment for local development.

## Next Steps

This minimal setup serves as the foundation for building a complete MLOps pipeline. Consider these next steps:

### Pipeline Components
- **Kubeflow Pipelines**: Add pipeline CRDs and Argo Workflows for orchestrating ML workflows
- **KFServing/KServe**: Deploy model serving infrastructure for inference endpoints
- **Katib**: Integrate hyperparameter tuning and AutoML capabilities

### Data Management
- **MinIO**: Add S3-compatible object storage for datasets and model artifacts
- **Persistent Volumes**: Replace emptyDir with persistent storage for notebook data
- **Data Versioning**: Integrate DVC or similar for dataset versioning

### Model Lifecycle
- **MLflow**: Add experiment tracking and model registry
- **Model Training Jobs**: Create Kubernetes Jobs/CronJobs for automated training
- **CI/CD Integration**: Connect with GitHub Actions for automated model deployment

### Monitoring & Observability
- **Prometheus + Grafana**: Monitor model performance and resource usage
- **Model Drift Detection**: Implement data/concept drift monitoring
- **Logging**: Centralized logging with ELK stack or similar

### Security & Governance
- **RBAC**: Implement role-based access control for different user types
- **Network Policies**: Secure inter-service communication
- **Model Governance**: Add model approval workflows and compliance tracking

### Production Readiness
- **Multi-environment**: Separate dev/staging/prod clusters
- **GitOps**: Implement ArgoCD for declarative deployments
- **Backup/Recovery**: Add disaster recovery procedures for critical components
