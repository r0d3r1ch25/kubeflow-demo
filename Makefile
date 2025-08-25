# Cluster configuration
CLUSTER_NAME ?= kubeflow-cluster

.PHONY: cluster-down cluster-up token status

# Delete previous cluster
cluster-down:
	@echo "Deleting old cluster if exists..."
	-k3d cluster delete $(CLUSTER_NAME) || true

# Create cluster
cluster-up:
	@echo "Creating k3d cluster $(CLUSTER_NAME)..."
	k3d cluster create $(CLUSTER_NAME) \
		--agents 1 \
		--k3s-arg "--disable=traefik@server:0"
	@echo "Cluster created! Using port-forwarding for services."
	@echo "Deploying Kubeflow components..."
	kubectl apply -k k8s/
	@echo "\nStarting port-forwarding (run in background)..."
	@echo "Use 'make forward' to start port-forwarding after cluster is ready"


# Get Jupyter Notebook token
token:
	@echo "Fetching Jupyter Notebook token..."
	@kubectl logs $$(kubectl get pods -n kubeflow -l app=jupyter-notebook -o jsonpath='{.items[0].metadata.name}') -n kubeflow 2>/dev/null | grep "token=" | sed 's/.*token=//' || echo "No token required (passwordless setup)"

# Check status of all components
status:
	@echo "=== Kubeflow Components Status ==="
	@kubectl get pods -n kubeflow
	@echo "\n=== Monitoring Components Status ==="
	@kubectl get pods -n monitoring
	@echo "\n=== Services ==="
	@kubectl get svc -n kubeflow
	@kubectl get svc -n monitoring
	@echo "\n=== Access URLs (after running 'make forward') ==="
	@echo "Kubeflow Pipelines UI: http://localhost:8080"
	@echo "MinIO Console: http://localhost:9001 (user: minio, pass: minio123)"
	@echo "Jupyter Notebook: http://localhost:8888"
	@echo "Grafana Dashboard: http://localhost:3000 (user: admin, pass: admin)"

# Start port-forwarding for all services
forward:
	@echo "Starting port-forwarding for all services..."
	@echo "Press Ctrl+C to stop all port-forwards"
	@kubectl port-forward -n kubeflow svc/ml-pipeline-ui 8080:80 &
	@kubectl port-forward -n kubeflow svc/minio-console-service 9001:9001 &
	@kubectl port-forward -n kubeflow svc/jupyter-service 8888:80 &
	@kubectl port-forward -n monitoring svc/grafana-service 3000:3000 &
	@wait

# Stop all port-forwarding
stop-forward:
	@echo "Stopping all port-forwards..."
	@pkill -f "kubectl port-forward" || true