# Infrastructure Setup Guide

## Introduction
Welcome to the **Infra-Setup** directory! This guide provides a structured step-by-step approach to setting up all the necessary infrastructure for **Canary Deployment with Argo Rollouts**. Each infrastructure component plays a crucial role in ensuring **progressive traffic shifting, automated rollback mechanisms, and real-time monitoring**.

### 📌 **Before You Begin**
It is **highly recommended** to first visit the project's main README to gain a **comprehensive understanding** of the deployment architecture:  
📖 [**Project's README**](https://github.com/Godfrey22152/Canary-Deployment-with-Argo-Rollout/blob/main/README.md)

---

## **Infrastructure Setup Steps (In Order)**

### 1️⃣ **Set Up a Kubernetes Cluster**
📌 **Why?** A Kubernetes cluster serves as the foundation for deploying and managing containerized applications. This project uses Kubeadm to create a multi-node cluster, Vagrant for automation, and MetalLB for LoadBalancer functionality to route external traffic effectively.
🚀 **Technology Used:** Kubeadm, Vagrant, VirtualBox, MetalLB (for Load Balancing). Set up your Kubernetes cluster by following this guide:  

🔗 **[Kubernetes Cluster Setup Guide](https://github.com/Godfrey22152/multi-node-k8s-setup-with-Vagrant-Kubeadm-and-MetalLB)**  

---

### 2️⃣ **Install and Configure NGINX Ingress Controller**
📌 **Why?** Since the application requires controlled access, NGINX Ingress Controller is installed to manage external traffic, enabling secure routing between different application versions during the Canary Deployment process. Configure it using the guide below:

🔗 **[NGINX Ingress Setup Guide](https://github.com/Godfrey22152/Canary-Deployment-with-Argo-Rollout/blob/main/Infra-Setup/Ingress-Nginx.md)**  

---

### 3️⃣ **Deploy Argo Rollouts for Canary Deployment**
📌 **Why?** **Argo Rollouts** is the **core deployment controller** that enables **progressive traffic shifting** from a **stable release** to a **canary release**. It ensures a **safe, automated rollout strategy** with **rollback mechanisms** based on real-time monitoring of application performance. Follow this guide:  

🔗 **[Argo Rollout Setup Guide](https://github.com/Godfrey22152/Canary-Deployment-with-Argo-Rollout/blob/main/Infra-Setup/argo-rollout-setup/argo-rollout.md)**  

---

### 4️⃣ **Set Up Prometheus Stack for Monitoring**
📌 **Why?** **Monitoring is critical** to track the health and performance of the canary release. To track application health and rollout performance, **Prometheus** is deployed alongside **Grafana** for real-time visualization. This ensures that rollback decisions are based on live data. Follow the guide below to set up the monitoring stack:

🔗 **[Prometheus Stack Installation Guide](https://github.com/Godfrey22152/Canary-Deployment-with-Argo-Rollout/blob/main/Infra-Setup/monitoring-setup/Prometheus_Stack_Installation.md)**  

---

### 5️⃣ **Configure Nexus Repository for Artifact Storage**
📌 **Why?** To securely store security reports, and build artifacts, a **Nexus Repository** is required. The CI/CD pipeline pushes security scan reports here for better traceability and compliance. 
**Nexus Repository** acts as an artifact manager, ensuring **version control** and security of deployment assets. Set it up using the guide below:  

🔗 **[Nexus Repository Setup Guide](https://github.com/Godfrey22152/Canary-Deployment-with-Argo-Rollout/blob/main/Infra-Setup/Nexus-Artifacts-server.md)**  

---

### 6️⃣ **Set Up a Self-Hosted GitHub Actions Runner**
📌 **Why?** Since the GitHub Actions workflow involves resource-intensive tasks like Docker image building and security scanning, using a self-hosted runner is essential. This ensures exclusive access to all project files, allowing for seamless execution of the pipeline without limitations imposed by GitHub’s hosted runners. Set it up using the guide below:

🔗 **[Self-Hosted Runner Setup Guide](https://github.com/Godfrey22152/Canary-Deployment-with-Argo-Rollout/blob/main/self-hosted-runner/README.md)**  

---

### 7️⃣ **GitHub Actions Workflow Breakdown**
📌 **Why?** The GitHub Actions workflow automates **continuous integration (CI) and continuous deployment (CD)**. This section provides an **in-depth breakdown** of how the pipeline functions.  

🔗 **[GitHub Actions Workflow Overview](https://github.com/Godfrey22152/Canary-Deployment-with-Argo-Rollout/blob/main/Infra-Setup/GitHub-Actions-Workflow-Breakdown.md)**  

---

## **🔑 Requirements**
To successfully execute the GitHub Actions workflow associated with this project, ensure that the following **GitHub Secrets** are configured:

| Secret Name          | Description |
|----------------------|-------------|
| `DOCKER_HUB_PAT`     | Docker Hub personal access token. |
| `DOCKER_HUB_USER`    | Docker Hub username. |
| `NEXUS_USERNAME`     | Username for Nexus Repository. |
| `NEXUS_PASSWORD`     | Password for Nexus Repository. |
| `NEXUS_URL`         | URL of the Nexus Repository. |
| `KUBE_CONFIG`       | Base64-encoded Kubernetes config for `kubectl` access. |

---

## **Need Help? Connect With Me!** 🤝
If you encounter any challenges setting up this project, feel free to **reach out** and connect with me:

- **LinkedIn**: [Your LinkedIn Profile](https://www.linkedin.com/in/your-profile)  
- **X (Twitter)**: [Your Twitter Handle](https://twitter.com/your-handle)  
- **GitHub**: [Your GitHub Profile](https://github.com/Godfrey22152)  

---

Following these steps ensures a **seamless setup** for your infrastructure. 🚀 Happy deploying!
