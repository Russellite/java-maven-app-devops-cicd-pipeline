# Java-Maven-App devops CI/CD Pipeline

This project demonstrates complete Devops workflow:

- Docker containerization
- Kubernetes deployment
- Helm packaging
- Jenkins CI/CD
- Horizontal Pod Autoscaling


## Tech Stack

- Java (Maven)
- Docker
- Kubernetes
- Helm Jenkins

# Application Overview

This is Java Maven eb Application packaged as a JAR file.

The application runs on port *8080*

## Docker Setup

The project uses a muliti-stage Docker build:

- Maven builds the application into a JAR file
- Amazon Corretto JRE runs the packaged JAR file.

### Build Docker Image

docker build -t java-maven-app:latest .

###

Deployment:

CPU requests and limits defined

Container port: 8080

Service

Type: ClusterIP

Exposes port 80 → container 8080

HPA

CPU-based autoscaling

Min replicas: 1

Max replicas: 5

Ingress

NGINX Ingress Controller

Exposed via NodePort on worker node

Accessed via:

http://<worker-node-public-ip>:<nodeport>

Bare-Metal Setup

Cluster deployed on:

1 Control Plane (DigitalOcean Droplet)

1 Worker Node (DigitalOcean Droplet)

Ingress controller exposed via NodePort (since LoadBalancer is not available on bare metal).

### Helm Deployment

The application is packaged using a custom Helm chart located under:

helm/java-maven-app

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

#### Install / Upgrade with Helm

Render templates:

helm template java-app-maven helm/java-maven-app -n test

Deploy or upgrade:

helm upgrade --install java-app-maven helm/java-maven-app \
  -n test --create-namespace \
  --set image.repository=giftedition/java-maven-app \
  --set image.tag=5

Migration to Helm

Initially, the application was deployed using raw Kubernetes manifests via:

kubectl apply -f k8s/

The deployment was later migrated to Helm for better versioning, templating, and CI/CD automation.

Raw manifests remain in the k8s/ directory for reference.

