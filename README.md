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

This command will wait for the notebook pod to be ready.

### Step 4: Access Your Notebook

1.  **Port-forward to the notebook:**
    ```bash
    make port-forward
    ```
    This will forward port 8888 on your local machine to the notebook pod. It will bind to `0.0.0.0` so you can access it from other devices on the same network.

2.  **Get the access token:**
    ```bash
    make token
    ```
    This will print the access token for the Jupyter notebook.

3.  **Access the notebook:**
    Open `http://<your-ip-address>:8888` in your browser and enter the token.

**Keep the `make port-forward` terminal open** - closing it stops the port forwarding.

## Development

This repository includes a `Makefile` with several useful targets for development:

- `make cluster`: Create the k3d cluster.
- `make delete`: Delete the k3d cluster.
- `make kubeflow`: Install the Kubeflow components.
- `make notebooks`: Deploy the notebook.
- `make pods`: List all pods in the `kubeflow` namespace.
- `make port-forward`: Port-forward to the notebook.
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
- If port-forward fails, ensure the pod is `Running` first.
- If cluster creation fails, delete with `make delete` and retry.

This setup provides a lightweight Kubeflow environment for local development.
