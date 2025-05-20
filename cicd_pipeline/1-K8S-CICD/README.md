---

# CI/CD Pipeline with GitLab, Kubernetes, and Container Registry

This document outlines a Continuous Integration and Continuous Deployment (CI/CD) workflow using GitLab, GitLab Runner, Container Registry, and Kubernetes.

## Pipeline Overview

The following steps illustrate the CI/CD process:

### 1. Developer Commit/Push

* A developer writes code and pushes changes to **GitLab Repository A** (REPO A).
* This commit triggers the CI/CD pipeline.

### 2. Build Image

* **GitLab Runner** picks up the pipeline job.
* The runner builds a Docker image based on the code and Dockerfile present in the repository.

### 3. Push to Container Registry

* The built Docker image is pushed to a **Container Registry** (e.g., GitLab Container Registry or Docker Hub).

### 4. Trigger Kubernetes Deployment

* GitLab CI/CD pipeline authorizes and interacts with **GitLab Repository B** (REPO B).
* This triggers a deployment to Kubernetes (K8s) using an **Agent Connection (Tunnel)** established between GitLab and the Kubernetes cluster.

### 5. Kubernetes Pulls Image

* The Kubernetes cluster pulls the latest image from the container registry.
* The application is deployed/updated in the cluster.

## Key Components

| Component           | Description                                                       |
| ------------------- | ----------------------------------------------------------------- |
| GitLab Repositories | Stores source code and CI/CD pipeline configuration.              |
| GitLab Runner       | Executes CI/CD jobs such as building and pushing Docker images.   |
| Container Registry  | Hosts Docker images (e.g., GitLab Container Registry).            |
| Kubernetes (K8s)    | Deploys the application using the latest image from the registry. |
| Agent Connection    | Secure tunnel for GitLab to interact with the Kubernetes cluster. |

## Prerequisites

* GitLab account with CI/CD enabled.
* GitLab Runner installed and registered.
* Dockerfile in the repository for image building.
* Access to a container registry.
* Kubernetes cluster with GitLab Agent installed and configured.

## Conclusion

This pipeline automates the process from code commit to deployment, ensuring faster and more reliable delivery of applications to production using GitLab and Kubernetes.

--

![image](https://github.com/user-attachments/assets/99cc86d5-3536-4098-887f-e868759c5c9a)
