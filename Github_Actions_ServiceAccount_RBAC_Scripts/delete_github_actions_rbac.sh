#!/bin/bash

# Define namespace
NAMESPACE="argo-rollouts"
ROLE="github-actions-role"
ROLEBINDING="github-actions-rolebinding"
SECRET="github-actions-secret"
SERVICEACCOUNT="github-actions-svc"

# Delete the Secret
echo "Deleting Secret $SECRET in namespace $NAMESPACE..."
kubectl delete secret $SECRET -n $NAMESPACE

# Delete the RoleBinding
echo "Deleting RoleBinding $ROLEBINDING in namespace $NAMESPACE..."
kubectl delete rolebinding $ROLEBINDING -n $NAMESPACE

# Delete the Role
echo "Deleting Role $ROLE in namespace $NAMESPACE..."
kubectl delete role $ROLE -n $NAMESPACE

# Delete the ServiceAccount
echo "Deleting ServiceAccount $SERVICEACCOUNT in namespace $NAMESPACE..."
kubectl delete serviceaccount $SERVICEACCOUNT -n $NAMESPACE

# Verify that the resources are deleted
echo "Verifying that all resources are deleted..."
kubectl get secret $SECRET -n $NAMESPACE >/dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "Error: Secret $SECRET was not deleted."
else
  echo "Secret $SECRET deleted successfully."
fi

kubectl get rolebinding $ROLEBINDING -n $NAMESPACE >/dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "Error: RoleBinding $ROLEBINDING was not deleted."
else
  echo "RoleBinding $ROLEBINDING deleted successfully."
fi

kubectl get role $ROLE -n $NAMESPACE >/dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "Error: Role $ROLE was not deleted."
else
  echo "Role $ROLE deleted successfully."
fi

kubectl get serviceaccount $SECRET -n $NAMESPACE >/dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "Error: ServiceAccount $SECRET was not deleted."
else
  echo "ServiceAccount $SECRET deleted successfully."
fi
