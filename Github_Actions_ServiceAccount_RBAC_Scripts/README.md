# Github Actions Service Account RBAC Setup for Kubernetes

This repository contains the necessary scripts and configurations to automate the creation and deletion of a **Github Actions Service Account** in the `argo-rollouts` namespace, along with the associated **RBAC (Role-Based Access Control)** policies and **Secret**.

## Files Overview

- **`github_actions_rbac_config.yaml`**: Contains the Kubernetes definitions for:
  - **ServiceAccount**: `github-actions-svc` in the `argo-rollouts` namespace.

    ```bash
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: github-actions-svc
      namespace: argo-rollouts
    ```

  - **Role**: `github-actions-role`, granting access to various Kubernetes resources (pods, services, configmaps, etc.).

    ```bash
    apiVersion: rbac.authorization.k8s.io/v1
    kind: Role
    metadata:
      name: github-actions-role
      namespace: argo-rollouts
    rules:

      # Permissions for core API Group
      - apiGroups: [""]
        resources:
          - pods
          - configmaps
          - events
          - endpoints
          - namespaces
          - nodes
          - secrets
          - persistentvolumes
          - persistentvolumeclaims
          - resourcequotas
          - replicationcontrollers
          - services
          - serviceaccounts
        verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]

      # Permissions for app API group
      - apiGroups: ["apps"]
        resources:
          - deployments
          - replicasets
          - daemonsets
          - statefulsets
        verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]

      # Permissions for Networking API group
      - apiGroups: ["networking.k8s.io"]
        resources:
          - ingresses
        verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]


      # Permissions for Autoscaling API group
      - apiGroups: ["autoscaling"]
        resources:
          - horizontalpodautoscalers
        verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]

      # Permissions for batch API Group
      - apiGroups: ["batch"]
        resources:
          - jobs
          - cronjobs
        verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
    
    ```

  - **RoleBinding**: `github-actions-rolebinding`, binding the role to the `github-actions-svc` ServiceAccount.

    ```bash
    apiVersion: rbac.authorization.k8s.io/v1
    kind: RoleBinding
    metadata:
      name: github-actions-rolebinding
      namespace: argo-rollouts
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: Role
      name: github-actions-role
    subjects:
    - namespace: argo-rollouts
      kind: ServiceAccount
      name: github-actions-svc
    ```

  - **Secret**: `github-actions-secret`, containing the service account token for authentication.

    ```bash
    apiVersion: v1
    kind: Secret
    type: kubernetes.io/service-account-token
    metadata:
      name: github-actions-secret
      namespace: argo-rollouts
      annotations:
        kubernetes.io/service-account.name: github-actions-svc
    ```

- **`create_github_actions_rbac.sh`**: A bash script that automates the creation of the Github Actions Service Account, RBAC resources, and Secret. It also retrieves and displays the service account's secret token.

- **`delete_github_actions_rbac.sh`**: A bash script to delete all resources created by the Github Actions RBAC setup (ServiceAccount, Role, RoleBinding, Secret).

## Prerequisites

Before running these scripts, ensure you have:
1. **kubectl** installed and configured to communicate with your Kubernetes cluster.
2. Proper permissions to create and delete resources in the `argo-rollouts` namespace.

## Instructions

### 1. Create Github Actions Service Account and RBAC Resources

To create the Github Actions Service Account and associated RBAC resources, run the `create_github-actions_rbac.sh` script.

#### Steps:
1. Clone the repository and navigate to the project directory.

   ```bash
   git clone https://github.com/Godfrey22152/Canary-Deployment-with-Argo-Rollout.git
   cd Github_Actions_ServiceAccount_RBAC_Scripts
   ```
2. Make the `create_github_actions_rbac.sh` script executable:
   ```bash
   chmod +x create_github_actions_rbac.sh
   ```
3. Run the script:
   ```bash
   ./create_github_actions_rbac.sh
   ```

#### What the Script Does:
- It checks if the `argo-rollouts` namespace exists; if not, it creates the namespace.
- It applies the `github_actions_rbac_config.yaml` to create the **Github Actions ServiceAccount**, **Role**, **RoleBinding**, and **Secret**.
- It waits for the secret to be created and displays the token associated with the `github-actions-svc` ServiceAccount.

#### Example Output:
```bash
Namespace argo-rollouts does not exist. Creating namespace...
namespace/argo-rollouts created
Creating Github Actions ServiceAccount, Role, RoleBinding, and Secret...
serviceaccount/github-actions-svc created
role.rbac.authorization.k8s.io/github-actions-role created
rolebinding.rbac.authorization.k8s.io/github-actions-rolebinding created
secret/github-actions-secret created
NAME                 SECRETS   AGE
github-actions-svc   0         1s
NAME                  CREATED AT
github-actions-role   2025-02-25T20:54:52Z
NAME                         ROLE                       AGE
github-actions-rolebinding   Role/github-actions-role   2s
Waiting for the github-actions-secret secret to be created...
ServiceAccount secret created: github-actions-secret
Secret token for the ServiceAccount github-actions-svc: <your-secret-token>
Github-actions service account and RBAC resources created successfully!
```

### 2. Delete Github Actions Service Account and RBAC Resources

To delete all resources created by the Github-actions-svc RBAC setup, use the `delete_github_actions_rbac.sh` script.

#### Steps:
1. Make the `delete_github_actions_rbac.sh` script executable:
   ```bash
   chmod +x delete_github_actions_rbac.sh
   ```
2. Run the script:
   ```bash
   ./delete_github_actions_rbac.sh
   ```

#### What the Script Does:
- Deletes the **Secret**, **RoleBinding**, **Role**, and **ServiceAccount** associated with Github-actions-svc in the `argo-rollouts` namespace.
- Verifies that each resource has been deleted successfully.

#### Example Output:
```bash
Deleting Secret github-actions-secret in namespace argo-rollouts...
secret "github-actions-secret" deleted
Deleting RoleBinding github-actions-rolebinding in namespace argo-rollouts...
rolebinding.rbac.authorization.k8s.io "github-actions-rolebinding" deleted
Deleting Role github-actions-role in namespace argo-rollouts...
role.rbac.authorization.k8s.io "github-actions-role" deleted
Deleting ServiceAccount github-actions-svc in namespace argo-rollouts...
serviceaccount "github-actions-svc" deleted
Verifying that all resources are deleted...
Secret github-actions-secret deleted successfully.
RoleBinding github-actions-rolebinding deleted successfully.
Role github-actions-role deleted successfully.
ServiceAccount github-actions-secret deleted successfully.
```

## File Details

### `github_actions_rbac_config.yaml`
This file contains the Kubernetes resources for `Github Actions Service Account` RBAC setup in the `argo-rollouts` namespace:

- **ServiceAccount: `github-actions-svc`**
- **Role: `github-actions-role`** with permissions to manage various Kubernetes resources (pods, services, configmaps, etc.).
- **RoleBinding: `github-actions-rolebinding`** that binds the `github-actions-role` to the `github-actions-svc` ServiceAccount.
- **Secret: `github-actions-secret`** containing the service account token for authentication.

### `create_github_actions_rbac.sh`

- **Purpose**: Automates the creation of Github Actions' ServiceAccount, Role, RoleBinding, and Secret.
- **Namespace**: The script creates resources in the `argo-rollouts` namespace.
- **Output**: After successful creation, the script displays the service account's secret token.

### `delete_github_actions_rbac.sh`

- **Purpose**: Automates the deletion of Github Actions' ServiceAccount, Role, RoleBinding, and Secret.
- **Namespace**: The script deletes resources in the `argo-rollouts` namespace.
- **Verification**: Verifies that the resources have been deleted.

## Notes

- The service-account-token retrieved by the `create_github_actions_rbac.sh` script can be used to authenticate the Github actions service account in your Kubernetes cluster.
- Ensure that you securely store the token as it provides access to the specified Kubernetes resources.
- The service-account-token can be found using this command:

```bash
kubectl describe secrets <SECRET-NAME> -n <NAMESPACE>

# For Instance:
kubectl describe secrets github-actions-secret -n argo-rollouts
```
