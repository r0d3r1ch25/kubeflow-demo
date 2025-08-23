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

## Known Issues and Debugging Status

### ML Pipeline API Server (ml-pipeline) Pod Not Ready

The `ml-pipeline` pod is currently not becoming `READY` (0/1). The logs indicate an "Access denied" error when connecting to the MySQL database, specifically `Error 1045: Access denied for user 'root'@'...' (using password: NO)`.

**Current Status:**
The `kubeflow-minimal.yaml` has been updated to use `MYSQL_USER` and `MYSQL_PASSWORD` environment variables for the `ml-pipeline` deployment, and `MYSQL_ROOT_HOST: "0.0.0.0"` for the `mysql` deployment. However, the MySQL logs still show `root@localhost is created with an empty password`. This suggests an issue with how the MySQL Docker image initializes the root password when using an `emptyDir` volume.

### Kubeflow Pipeline UI (ml-pipeline-ui) Error

The Kubeflow Pipeline UI (accessible via `http://localhost:31380`) shows an error: "failed to retrieve list of pipelines." This is due to the UI being unable to connect to the `ml-pipeline` API server.

**Current Status:**
The `ml-pipeline-ui` deployment has been configured with `ML_PIPELINE_SERVICE_HOST: ml-pipeline` and `ML_PIPELINE_SERVICE_PORT: 8888`. The `ml-pipeline-ui` pod logs confirm it is attempting to connect to `ml-pipeline:8888`. The connection is being refused because the `ml-pipeline` API server is not yet ready to serve HTTP traffic on that port (as indicated by the `ml-pipeline` pod's `0/1` readiness status).

## Cleanup

To delete the k3d cluster, run the following command:

```bash
make cluster-down
```