# Kubeflow Pipelines MLMD Fix Guide

## Issue
**Error:** "Cannot get MLMD objects from Metadata store. Cannot find context with typeName: system.PipelineRun"

## Root Cause
Pipeline workflows missing required instance ID label `workflows.argoproj.io/controller-instanceid: kubeflow-pipelines` that workflow controller needs to process workflows.

## Solution Applied
1. **ml-pipeline-api-server** - Added `WORKFLOW_CONTROLLER_INSTANCE_ID=kubeflow-pipelines`
2. **workflow-controller** - Added `--namespaced` flag and complete RBAC permissions
3. **Argo CRDs** - Added missing cronworkflows, workflowtemplates, clusterworkflowtemplates
4. **Init containers** - Proper startup order dependencies

## Verification After Restart
```bash
# Check workflow has correct label
kubectl get workflows -n kubeflow -o yaml | grep "controller-instanceid"

# Verify execution
kubectl get workflows -n kubeflow
kubectl get pods -n kubeflow | grep test-pipeline

# Check MLMD context creation
kubectl logs -n kubeflow $(kubectl get pods -n kubeflow -l app=metadata-writer -o name) --tail=5
```

## Status: ✅ RESOLVED
New pipeline runs automatically get correct instance ID and execute properly.