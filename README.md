# Kubeflow Demo

This repository provides a minimal setup for running Kubeflow on a local k3d cluster.

## Prerequisites

Before you begin, ensure you have the following tools installed:

*   [make](https://www.gnu.org/software/make/)
*   [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
*   [k3d](https://k3d.io/v5.6.0/#installation)

## Installation

1.  **Create the k3d cluster:**

    ```bash
    make cluster-up
    ```
    This command creates a k3d cluster with the necessary ports exposed to your local network.

2.  **Deploy Kubeflow components:**

    ```bash
    kubectl apply -f kubeflow-minimal.yaml
    ```
    This command deploys a minimal set of Kubeflow components and their dependencies.

## Usage

Once the installation is complete, you can access the following services in your browser:

*   **Kubeflow Pipeline UI:** [http://localhost:31380](http://localhost:31380)
*   **MinIO Console:** [http://localhost:31390](http://localhost:31390)
*   **Jupyter Notebook:** [http://localhost:31400](http://localhost:31400)

If you want to access these services from other devices on your local network, replace `localhost` with your machine's local IP address.

## Cleanup

To delete the k3d cluster, run the following command:

```bash
make cluster-down
```