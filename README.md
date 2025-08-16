# Kubeflow Demo

Minimal Kubeflow setup for local development on Mac using k3d.

## Step-by-Step Tutorial

### Step 1: Create the Kubernetes Cluster
```bash
make cluster
```
This creates a k3d cluster named `kubeflow-demo` with port 8080 exposed. Wait for it to complete.

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

### Step 4: Check if Everything is Running
```bash
make pods
```
Wait until you see the notebook pod in `Running` status. This may take 1-2 minutes as it downloads the Jupyter image.

### Step 5: Access Your Notebook
```bash
make port-forward
```
Open http://localhost:8080 in your browser. You'll see the Jupyter interface.

**Keep this terminal open** - closing it stops the port forwarding.

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

- If `make pods` shows `Pending` status, wait longer for image download
- If port-forward fails, ensure the pod is `Running` first
- If cluster creation fails, delete with `make delete` and retry