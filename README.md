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

# Apllcation Overview

This is Java Maven eb Application packaged as a JAR file.

The application runs on port *8080*

## Docker Setup

The project uses a muliti-stage Docker build:

- Maven builds the application into a JAR file
- Amazon Corretto JRE runs the packaged JAR file.

### Build Docker Image

docker build -t java-maven-app:latest .

