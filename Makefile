# Kubeflow Demo Makefile
CLUSTER_NAME := kubeflow-demo
NAMESPACE := kubeflow

.PHONY: cluster delete notebooks pods port-forward

# Create k3d cluster
cluster:
	@echo "Creating k3d cluster..."
	k3d cluster create $(CLUSTER_NAME) \
		--agents 1 \
		--k3s-arg "--disable=traefik@server:0" \
		--port "8080:80@loadbalancer"

# Delete k3d cluster
delete:
	@echo "Deleting k3d cluster..."
	k3d cluster delete $(CLUSTER_NAME)

# Deploy notebook CRD
notebooks:
	@echo "Creating namespace and deploying notebook..."
	kubectl create namespace $(NAMESPACE) --dry-run=client -o yaml | kubectl apply -f -
	kubectl apply -f k8s/notebooks/notebook.yaml

# List all pods in kubeflow namespace
pods:
	kubectl get pods -n $(NAMESPACE)

# Port forward kubeflow dashboard
port-forward:
	@echo "Port forwarding to localhost:8080..."
	kubectl port-forward -n $(NAMESPACE) svc/notebook-python-demo 8080:8888