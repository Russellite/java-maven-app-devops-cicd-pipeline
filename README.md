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

