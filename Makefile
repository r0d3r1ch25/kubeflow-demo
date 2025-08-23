# Cluster configuration
CLUSTER_NAME ?= kubeflow-cluster

.PHONY: cluster-down cluster-up

# Delete previous cluster
cluster-down:
	@echo "Deleting old cluster if exists..."
	-k3d cluster delete $(CLUSTER_NAME) || true

# Create cluster with ports for NodePort usage
cluster-up:
	@echo "Creating k3d cluster $(CLUSTER_NAME)..."
	k3d cluster create $(CLUSTER_NAME) \
		--agents 1 \
		--k3s-arg "--disable=traefik@server:0"
	@echo "Cluster created! NodePorts will be used for services."

