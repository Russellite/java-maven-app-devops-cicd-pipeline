🚀 Java Maven DevOps CI/CD Pipeline

This project demonstrates an end-to-end DevOps workflow for a Java Maven application deployed to a Kubernetes cluster using Helm and automated via Jenkins.

It covers:

Docker containerization (multi-stage build)

Kubernetes deployment (Deployment, Service, HPA, Ingress)

Helm-based application packaging

Jenkins CI/CD automation

Bare-metal Kubernetes cluster (DigitalOcean)

Immutable image tagging using build numbers

🧰 Tech Stack

Java (Maven)

Docker

Kubernetes

Helm

Jenkins

DockerHub

DigitalOcean (Bare-metal cluster)

🖥 Application Overview

This is a Java Maven web application packaged as a JAR file.

Application Port: 8080

Built using Maven

Served via NGINX Ingress

🐳 Docker Setup

The project uses a multi-stage Docker build:

Maven builds the application into a JAR file

Amazon Corretto JRE runs the packaged JAR

🔨 Build Docker Image
docker build -t java-maven-app:latest .
☸ Kubernetes Deployment

The application is deployed to a Kubernetes cluster with the following components:

📦 Deployment

CPU requests and limits defined

Container port: 8080

Managed via Helm

🔌 Service

Type: ClusterIP

Exposes port 80 → container port 8080

📈 Horizontal Pod Autoscaler (HPA)

CPU-based autoscaling

Minimum replicas: 1

Maximum replicas: 5

🌐 Ingress

NGINX Ingress Controller

Exposed via NodePort (bare-metal setup)

Accessible via:

http://<worker-node-public-ip>:<nodeport>


🏗 Bare-Metal Cluster Setup

The Kubernetes cluster is deployed on DigitalOcean droplets:

1 Control Plane Node

1 Worker Node

Since this is a bare-metal setup:

LoadBalancer service type is not available

Ingress Controller is exposed via NodePort

📦 Helm Deployment

The application is packaged using a custom Helm chart located under:

helm/java-maven-app
📂 Helm Chart Structure
helm/java-maven-app/
│
├── Chart.yaml
├── values.yaml
└── templates/
    ├── deployment.yaml
    ├── service.yaml
    ├── hpa.yaml
    ├── ingress.yaml
    └── _helpers.tpl

🔧 Jenkins Shared Library

Reusable pipeline functions:

buildImage()

dockerLogin()

dockerPush()

This separates CI logic from orchestration and promotes scalable, maintainable pipelines.

🔍 Render Templates
helm template java-app-maven helm/java-maven-app -n test

🚀 Install / Upgrade
helm upgrade --install java-app-maven helm/java-maven-app \
  -n test --create-namespace \
  --set image.repository=giftedition/java-maven-app \
  --set image.tag=<BUILD_NUMBER>

Helm provides:

Versioned releases

Easier upgrades

Rollback capability

Clean parameterization

CI/CD-friendly deployment

🔄 Migration to Helm

Initially, the application was deployed using raw Kubernetes manifests:

kubectl apply -f k8s/

The deployment was later migrated to Helm for:

Better release management

Templating flexibility

CI/CD integration

Version tracking

Raw manifests remain in the k8s/ directory for reference.

🔁 CI/CD Pipeline

The Jenkins pipeline automates:

Docker image build

DockerHub push

Helm deployment

Kubernetes rollout verification

Deployment command used in Jenkins:

helm upgrade --install java-app-maven helm/java-maven-app \
  -n test \
  --set image.repository=giftedition/java-maven-app \
  --set image.tag=${BUILD_NUMBER}

Each build generates an immutable image tag based on the Jenkins build number.

📊 Release Management

List Helm releases:

helm ls -n test

Check release status:

helm status java-app-maven -n test

Rollback to previous revision:

helm rollback java-app-maven <REVISION> -n test


🏆 Key DevOps Concepts Demonstrated

Multi-stage Docker builds

Container registry integration (DockerHub)

Bare-metal Kubernetes architecture

Ingress configuration without cloud LoadBalancer

Horizontal Pod Autoscaling

Helm-based deployment packaging

Immutable image versioning

CI/CD automation with Jenkins

Release management and rollback with Helm

📈 Future Improvements

TLS configuration for Ingress

Helm chart versioning strategy

Automated rollback on deployment failure

Multi-environment support (dev/staging/prod)

Monitoring & logging integration (Prometheus/Grafana)