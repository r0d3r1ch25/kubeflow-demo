# Kubeflow Pipelines MLMD Issue - Final Resolution

## Issue
**Error:** "Cannot get MLMD objects from Metadata store. Cannot find context with typeName: system.PipelineRun"

## Root Causes Identified
1. **Missing Instance ID Label**: Workflows missing `workflows.argoproj.io/controller-instanceid: kubeflow-pipelines`
2. **Version Incompatibility**: persistenceagent 1.8.5 incompatible with API server 2.0.0
3. **Incomplete Argo Setup**: Missing CRDs and RBAC permissions

## Solutions Applied
1. **persistenceagent**: Updated to version 2.0.0 ✅
2. **workflow-controller**: Added `--namespaced` flag ✅
3. **Argo CRDs**: Added missing cronworkflows, workflowtemplates, clusterworkflowtemplates ✅
4. **RBAC**: Complete permissions including leases for leader election ✅
5. **Init containers**: Proper startup order dependencies ✅

## Current Status
- ✅ **Workflows execute properly** when instance ID label is present
- ✅ **Persistenceagent works** - no more RPC errors
- ✅ **MLMD contexts created** - workflows process successfully
- ❌ **Auto-labeling not working** - `WORKFLOW_CONTROLLER_INSTANCE_ID` env var doesn't auto-add labels

## Workaround Required
New workflows need manual instance ID label:
```bash
kubectl patch workflow <workflow-name> -n kubeflow --type='merge' -p='{"metadata":{"labels":{"workflows.argoproj.io/controller-instanceid":"kubeflow-pipelines"}}}'
```

## Files Modified
- `k8s/pipelines/deployments/ml-pipeline-persistenceagent-deployment.yaml` - Version 2.0.0
- `k8s/pipelines/deployments/workflow-controller-deployment.yaml` - Added --namespaced
- `k8s/pipelines/deployments/ml-pipeline-deploy.yaml` - Added WORKFLOW_CONTROLLER_INSTANCE_ID
- `k8s/pipelines/crds/missing-argo-crds.yaml` - Complete Argo CRDs
- `k8s/pipelines/rbac/argo-workflow-rbac.yaml` - Full RBAC permissions

## Status: ✅ MOSTLY RESOLVED
Core MLMD functionality works - workflows execute and create contexts when properly labeled.