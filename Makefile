# Cluster configuration
CLUSTER_NAME ?= kubeflow-cluster

.PHONY: cluster-down cluster-up token status

# Delete previous cluster
cluster-down:
	@echo "Deleting old cluster if exists..."
	-k3d cluster delete $(CLUSTER_NAME) || true

# Create cluster with ports for NodePort usage
cluster-up:
	@echo "Creating k3d cluster $(CLUSTER_NAME)..."
	k3d cluster create $(CLUSTER_NAME) \
		--agents 1 \
		--k3s-arg "--disable=traefik@server:0" \
		--port 0.0.0.0:31380:31380 \
		--port 0.0.0.0:31390:31390 \
		--port 0.0.0.0:31400:31400 \
		--port 0.0.0.0:31410:31410
	@echo "Cluster created! NodePorts will be used for services."
	@echo "Deploying Kubeflow components..."
	kubectl apply -k k8s/
	@echo "Waiting for pods to be ready..."
	kubectl wait --for=condition=ready pod -l app=minio -n kubeflow --timeout=600s
	kubectl wait --for=condition=ready pod -l app=ml-pipeline -n kubeflow --timeout=600s
	kubectl wait --for=condition=ready pod -l app=jupyter-notebook -n kubeflow --timeout=600s
	@echo "\n=== Access URLs ==="
	@echo "Kubeflow Pipelines UI: http://localhost:31380"
	@echo "MinIO Console: http://localhost:31390 (user: minio, pass: minio123)"
	@echo "Jupyter Notebook: http://localhost:31400"
	@echo "Grafana Dashboard: http://localhost:31410 (user: admin, pass: admin)"
	@echo "\nAll services are ready!"


# Get Jupyter Notebook token
token:
	@echo "Fetching Jupyter Notebook token..."
	@kubectl logs $$(kubectl get pods -n kubeflow -l app=jupyter-notebook -o jsonpath='{.items[0].metadata.name}') -n kubeflow | grep "token=" | sed 's/.*token=//' || echo "No token required (passwordless setup)"

# Check status of all components
status:
	@echo "=== Kubeflow Components Status ==="
	@kubectl get pods -n kubeflow
	@echo "\n=== Monitoring Components Status ==="
	@kubectl get pods -n monitoring
	@echo "\n=== Services ==="
	@kubectl get svc -n kubeflow
	@kubectl get svc -n monitoring
	@echo "\n=== Access URLs ==="
	@echo "Kubeflow Pipelines UI: http://localhost:31380"
	@echo "MinIO Console: http://localhost:31390 (user: minio, pass: minio123)"
	@echo "Jupyter Notebook: http://localhost:31400"
	@echo "Grafana Dashboard: http://localhost:31410 (user: admin, pass: admin)"
