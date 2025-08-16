# Kubeflow Demo Makefile
CLUSTER_NAME := kubeflow-demo
NAMESPACE := kubeflow

.PHONY: cluster delete kubeflow notebooks pods port-forward delete-notebook token

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

# Install minimal Kubeflow components
kubeflow:
	@echo "Installing Kubeflow components..."
	kubectl create namespace $(NAMESPACE) --dry-run=client -o yaml | kubectl apply -f -
	kubectl apply -f k8s/manifests/

# Deploy notebook CRD
notebooks:
	@echo "Creating namespace and deploying notebook..."
	kubectl create namespace $(NAMESPACE) --dry-run=client -o yaml | kubectl apply -f -
	kubectl apply -f k8s/notebooks/
	@echo "Waiting for notebook pod to be created..."
	@sleep 30
	@echo "Waiting for notebook pod to be ready..."
	@kubectl wait --for=condition=ready pod -l notebook-name=python-demo -n $(NAMESPACE) --timeout=300s
	@echo "Notebook is ready. Use 'make port-forward' and 'make token' to access it."

# List all pods in kubeflow namespace
pods:
	kubectl get pods -n $(NAMESPACE)

# Port forward notebook
port-forward:
	@echo "Port forwarding to 0.0.0.0:8888..."
	@kubectl port-forward --address 0.0.0.0 $(shell kubectl get pods -n kubeflow -l "notebook-name=python-demo" -o jsonpath='{.items[0].metadata.name}') -n $(NAMESPACE) 8888:8888

# Get notebook access token
token:
	@echo "Notebook access token:"
	@kubectl logs $(shell kubectl get pods -n kubeflow -l "notebook-name=python-demo" -o jsonpath='{.items[0].metadata.name}') -n $(NAMESPACE) | grep "token=" | head -n1 | sed 's/.*token=//'

# Delete notebook
delete-notebook:
	@echo "Deleting notebook..."
	kubectl delete notebooks python-demo -n $(NAMESPACE)
