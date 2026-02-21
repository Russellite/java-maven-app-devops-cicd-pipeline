# 🚀 Deployment Flow

This document explains the complete CI/CD workflow used in this project.

---

## 🔁 End-to-End Pipeline Flow

1. Developer pushes code to GitHub
2. Jenkins pipeline is triggered
3. Docker image is built using multi-stage Dockerfile
4. Image is pushed to DockerHub
5. Helm upgrades or installs the Kubernetes release
6. Kubernetes performs rolling update
7. NGINX Ingress routes traffic to new pods
8. End users access the updated application

---

## 🧱 Detailed Breakdown

### 1️⃣ Code Commit

Source code is pushed to GitHub.

Jenkins is configured to monitor the repository and trigger a pipeline execution on new commits.

---

### 2️⃣ Docker Image Build

The pipeline executes:

- Multi-stage Docker build
- Maven builds JAR file
- Amazon Corretto runs the application

The image is tagged using:


${BUILD_NUMBER}


This ensures immutable versioning.

Example:


giftedition/java-maven-app:6


---

### 3️⃣ DockerHub Push

The built image is pushed to DockerHub.

This acts as the container registry for Kubernetes deployments.

---

### 4️⃣ Helm Deployment

Jenkins deploys using:

```bash
helm upgrade --install java-app-maven helm/java-maven-app \
  -n test \
  --set image.repository=giftedition/java-maven-app \
  --set image.tag=${BUILD_NUMBER}

Helm:

Renders templates

Applies Kubernetes manifests

Tracks release history

Enables rollback capability

5️⃣ Kubernetes Rolling Update

Kubernetes:

Detects new image tag

Creates new pods

Gradually terminates old pods

Ensures zero-downtime deployment

6️⃣ Horizontal Pod Autoscaling

The HPA monitors CPU usage and automatically scales:

Minimum replicas: 1

Maximum replicas: 5

7️⃣ Traffic Routing

Traffic flow:

User → Worker Node Public IP → NodePort → NGINX Ingress → ClusterIP Service → Pods

Since this is a bare-metal cluster:

LoadBalancer service type is not available

NodePort is used to expose Ingress externally

📊 Release Management

Helm tracks release versions:

helm ls -n test

Rollback example:

helm rollback java-app-maven <REVISION> -n test
🎯 Key DevOps Concepts Demonstrated

Immutable infrastructure

CI/CD automation

Infrastructure as Code

Helm-based release management

Kubernetes rolling updates

Autoscaling configuration

Bare-metal cluster networking


---

# 📄 docs/cluster-setup.md

```markdown
# ☸ Kubernetes Cluster Setup

This project uses a bare-metal Kubernetes cluster deployed on DigitalOcean droplets.

---

## 🖥 Infrastructure

The cluster consists of:

- 1 Control Plane Node
- 1 Worker Node

Both nodes are provisioned as DigitalOcean droplets.

---

## ⚙ Cluster Initialization

The cluster was initialized using kubeadm.

Control Plane:


kubeadm init


Worker Node:


kubeadm join <control-plane-ip>:6443 --token <token>


---

## 🌐 Networking

A CNI plugin (cilium) was installed to enable pod networking.

The cluster does not use a cloud provider integration.

Therefore:

- Service type `LoadBalancer` is unavailable
- NodePort is used for external exposure

---

## 🔌 NGINX Ingress Controller

Installed using Helm:

```bash
helm install app-nginx ingress-nginx/ingress-nginx \
  -n test 

Since this is a bare-metal cluster:

Ingress Controller is exposed via NodePort

Public worker node IP is used for external access

Access example:

http://<worker-node-public-ip>:<nodeport>


📈 Metrics Server

Metrics Server is installed to enable:

Horizontal Pod Autoscaling

CPU usage monitoring

🛡 Security Considerations

Access to Kubernetes API is secured via kubeconfig

Jenkins uses stored kubeconfig credentials

DockerHub credentials are stored securely in Jenkins

📊 Namespaces

Application is deployed in:

test

This allows isolation from other workloads.

🚀 Helm-Based Deployment

All Kubernetes resources are managed via Helm chart:

helm/java-maven-app

Helm ensures:

Parameterized deployment

Versioned releases

Easy rollback capability