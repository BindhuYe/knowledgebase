---

# CI/CD Pipeline with Jenkins, GitLab Registry, ArgoCD, and Kubernetes

This repository describes a CI/CD workflow for deploying applications to a Kubernetes cluster using Jenkins for continuous integration and ArgoCD for continuous deployment.

## Pipeline Overview

The pipeline follows these key steps:

### 1. Developer Commit

* A developer commits source code and supporting files to the **Jenkins Project Repository**.
* Files include:

  * Application source code
  * `Dockerfile`
  * `.gitlab-ci.yml` (if used in combination with GitLab CI)

### 2. Jenkins Pipeline Execution

* Jenkins is triggered by the commit.
* The pipeline performs the following:

  * `build_image`: Builds a Docker image from the `Dockerfile`.
  * `tag_latest_image`: Tags the image appropriately.
  * `update_manifest`: Updates the image tag in the Helm chart (`values.yaml`).

### 3. Push Image to GitLab Container Registry

* The built and tagged image is pushed to **GitLab Registry**.

### 4. Manifest Repo Update

* Jenkins updates the **Manifest Repository** with the new image tag.
* This repo contains:

  * Helm charts
  * `chart.yaml`, `values.yaml`
  * Kubernetes templates

### 5. ArgoCD Sync & Deployment

* **ArgoCD** detects changes in the Manifest Repository.
* It automatically syncs and applies the updated manifests to the **Kubernetes** cluster.
* This results in the deployment of the new application version.

## Key Components

| Component            | Description                                                       |
| -------------------- | ----------------------------------------------------------------- |
| Jenkins Project Repo | Stores application code and Dockerfile.                           |
| Jenkins Pipeline     | Automates image building, tagging, and manifest updates.          |
| GitLab Registry      | Hosts Docker images.                                              |
| Manifest Repo        | Contains Helm charts and Kubernetes manifests.                    |
| ArgoCD               | Monitors the Manifest Repo and syncs with the Kubernetes cluster. |
| Kubernetes           | Hosts the running application.                                    |

## Prerequisites

* Jenkins instance with pipeline support.
* GitLab Container Registry access.
* Helm charts defined for deployment.
* ArgoCD configured and connected to your Kubernetes cluster.
* Kubernetes cluster up and running.

## Benefits

* Decouples CI and CD responsibilities between Jenkins and ArgoCD.
* Provides clear version control via GitOps principles.
* Ensures consistency and repeatability in deployments.

---

