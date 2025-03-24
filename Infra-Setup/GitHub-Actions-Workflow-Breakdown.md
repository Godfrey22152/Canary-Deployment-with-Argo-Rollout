# Canary Deployment CI/CD Pipeline using GitHub Actions

## Overview
The project's **[GitHub Actions workflow](https://github.com/Godfrey22152/Canary-Deployment-with-Argo-Rollout/blob/main/.github/workflows/canary-deployment-workflow.yml)** is designed to automate the CI/CD process for the **Canary deployment pipeline**. The pipeline includes **code quality checks**, **security scanning**, **Docker image building**, and **Kubernetes deployment** using **Argo Rollouts**.

---

## Workflow Trigger
The workflow is triggered manually via `workflow_dispatch`, allowing the user to select the release type (`stable` or `canary`) before execution.

---

## Jobs and Steps Breakdown

### 1. **Build Job**
Runs on a self-hosted runner (`Canary Runner`) and performs the following tasks:

#### a. **Checkout Repository**
- Checks out the repository branch based on the selected release type.

#### b. **Set Up Python Environment**
- Installs **Python 3.10** and caches dependencies.

#### c. **Install Project Dependencies**
- Installs `flake8`, `pytest`, `pytest-cov`, and additional dependencies from `requirements.txt` if available.

#### d. **Linting with Flake8**
- Ensures Python code adheres to style and quality standards.

#### e. **Unit Testing & Code Coverage**
- Runs unit tests using `pytest` and generates a coverage report.
- Stores reports as workflow artifacts.

#### f. **Trivy Security Scan**
- Scans the repository for vulnerabilities and misconfigurations.
- Saves the report as an artifact.

#### g. **Static Code Analysis with Bandit**
- Performs security analysis on Python code.
- Stores the Bandit scan report as an artifact.

#### h. **Docker Image Build & Push**
- Configures Docker environment.
- Builds a Docker image with a timestamped tag.
- Pushes the image to Docker Hub.

#### i. **Docker Image Security Scan with Docker Scout**
- Runs security scans for vulnerabilities.
- Stores scan reports as artifacts.

#### j. **Upload Security Reports to Nexus Repository**
- Securely uploads all security scan results to a Nexus repository.

### 2. **Kubernetes Deployment**

#### a. **Fetch Deployment Manifests**
- Ensures deployment manifests are available from the `main` branch.

#### b. **Update Image Tag in Rollout Manifest**
- Modifies **[`Manifest_Files/quiz-app-rollout.yaml`](https://github.com/Godfrey22152/Canary-Deployment-with-Argo-Rollout/blob/51f8336579d816b97f143862926aa59b3de9299a/Manifest_Files/quiz-app-rollout.yaml#L44)** to use the newly built image tag.

#### c. **Deploy to Kubernetes Cluster**
- Applies deployment manifests using `kubectl`.
- Verifies deployment by listing rollout status, pods, services, and ingress resources in the `argo-rollouts` namespace.

---

## Requirements
To successfully run this workflow, the following GitHub Secrets must be configured:

- `DOCKER_HUB_PAT`: Docker Hub personal access token.
- `DOCKER_HUB_USER`: Docker Hub username.
- `NEXUS_USERNAME`: Username for Nexus Repository.
- `NEXUS_PASSWORD`: Password for Nexus Repository.
- `NEXUS_URL`: URL of the Nexus Repository.
- `KUBE_CONFIG`: Base64-encoded Kubernetes config for `kubectl` access.
   - To Convert `KUBE_CONFIG` to **base64**, Run the command on your cluster:
     ```sh
     base64 ~/.kube/config
     ```

---

## Artifact Storage
The workflow stores the following artifacts:
- **Pytest Unit Test Report**
- **Code Coverage Report**
- **Trivy Security Scan Report**
- **Bandit Security Scan Report**
- **Docker Scout Security Reports**
- **Updated Kubernetes Deployment Manifests**

---

## Deployment Validation
After the deployment, the following verification steps are performed:
- List **rollouts**, **pods**, **services**, and **ingress resources** to ensure correct deployment.

---

## Downloading Reports
- All generated reports can be downloaded from the workflow artifacts section in GitHub Actions.
- All generated reports are also stored in the **Nexus Repository**

---

## Conclusion
This GitHub Actions workflow automates the entire canary deployment pipeline, ensuring high code quality, security, and seamless Kubernetes deployment using Argo Rollouts.
- Kindly visit the **[Infrastructure Setup](https://github.com/Godfrey22152/Canary-Deployment-with-Argo-Rollout/blob/main/Infra-Setup/README.md)** folder for a detailed guide on setting up the project. 

