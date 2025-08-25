# Debug Commands for MLMD Issues

## Deploy debug pod
```bash
kubectl apply -f debug-mlmd.yaml
```

## Test MLMD connection
```bash
# Install dependencies and run test
kubectl exec -n kubeflow debug-mlmd -- bash -c "
pip install ml-metadata grpcio && 
python -c '
import grpc
from ml_metadata.proto import metadata_store_pb2
from ml_metadata.proto import metadata_store_service_pb2_grpc

channel = grpc.insecure_channel(\"metadata-grpc-service:8080\")
stub = metadata_store_service_pb2_grpc.MetadataStoreServiceStub(channel)

# Test connection
request = metadata_store_pb2.GetContextsByTypeRequest()
request.type_name = \"system.PipelineRun\"
response = stub.GetContextsByType(request)
print(f\"Found {len(response.contexts)} PipelineRun contexts\")
for ctx in response.contexts:
    print(f\"Context: {ctx.name}, ID: {ctx.id}\")
'"
```

## Check workflow execution
```bash
# Check if workflow pods are created
kubectl get pods -n kubeflow | grep -E "(test-pipeline|workflow)"

# Check workflow status
kubectl get workflows -n kubeflow -o yaml | grep -A 5 -B 5 "phase\|message"

# Check workflow controller logs
kubectl logs -n kubeflow $(kubectl get pods -n kubeflow -l app=workflow-controller -o name) --tail=20
```

## Clean up debug resources
```bash
kubectl delete -f debug-mlmd.yaml
```