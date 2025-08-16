# Kubeflow Demo Makefile
CLUSTER_NAME := kubeflow-demo
NAMESPACE := kubeflow
NOTEBOOK_PORT := 8888

.PHONY: cluster delete kubeflow notebooks pods delete-notebook token

# Create k3d cluster
cluster:
	@echo "Creating k3d cluster..."
	k3d cluster create $(CLUSTER_NAME) \
		--agents 1 \
		--port "0.0.0.0:$(NOTEBOOK_PORT):$(NOTEBOOK_PORT)@loadbalancer"

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
	@echo "Notebook is ready. Access it at http://localhost:8888 and use 'make token' for the access token."

# List all pods in kubeflow namespace
pods:
	kubectl get pods -n $(NAMESPACE)



# Get notebook access token
token:
	@echo "Notebook access token:"
	@kubectl logs $(shell kubectl get pods -n kubeflow -l "notebook-name=python-demo" -o jsonpath='{.items[0].metadata.name}') -n $(NAMESPACE) | grep "token=" | head -n1 | sed 's/.*token=//'

# Delete notebook
delete-notebook:
	@echo "Deleting notebook..."
	kubectl delete notebooks python-demo -n $(NAMESPACE)
