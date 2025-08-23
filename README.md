# Kubeflow Demo

This repository provides a minimal setup for running Kubeflow on a local k3d cluster.

## Prerequisites

Before you begin, ensure you have the following tools installed:

*   [make](https://www.gnu.org/software/make/)
*   [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
*   [k3d](https://k3d.io/v5.6.0/#installation)
*   [kustomize](https://kubernetes-sigs.github.io/kustomize/installation/)

## Installation

1.  **Create the k3d cluster:**

    ```bash
    make cluster-create
    ```

2.  **Install Kubeflow:**

    ```bash
    make install-kubeflow
    ```

## Usage

Once the installation is complete, you can access the Kubeflow dashboard by port-forwarding the istio-ingressgateway service:

```bash
kubectl port-forward -n istio-system svc/istio-ingressgateway 8080:80
```

Then, open your web browser and navigate to `http://localhost:8080`.

## Cleanup

To delete the k3d cluster and uninstall Kubeflow, run the following commands:

```bash
make uninstall-kubeflow
make cluster-delete
```
