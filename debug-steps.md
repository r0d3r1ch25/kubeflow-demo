# Debug Steps for MLMD Issues

## Quick Status Check
```bash
make status
```

## Check Metadata Components
```bash
# Check metadata-grpc connection
kubectl logs -n kubeflow $(kubectl get pods -n kubeflow -l app=metadata-grpc -o name) --tail=10

# Check metadata-writer
kubectl logs -n kubeflow $(kubectl get pods -n kubeflow -l app=metadata-writer -o name) --tail=10

# Test metadata store connection
kubectl exec -n kubeflow $(kubectl get pods -n kubeflow -l app=mysql -o name) -- mysql -u mlpipeline -e "SHOW DATABASES;"
```

## Check Pipeline API
```bash
# Check API server logs
kubectl logs -n kubeflow $(kubectl get pods -n kubeflow -l app=ml-pipeline-api-server -o name) --tail=20

# Check service endpoints
kubectl get endpoints ml-pipeline -n kubeflow
```

## Check Workflow Controller
```bash
# Check if workflows are being created
kubectl get workflows -n kubeflow

# Check workflow controller logs
kubectl logs -n kubeflow $(kubectl get pods -n kubeflow -l app=workflow-controller -o name) --tail=10
```