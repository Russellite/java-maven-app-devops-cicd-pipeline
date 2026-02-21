# 🛠 Troubleshooting & Debugging Notes

This document outlines real issues encountered during development and how they were resolved.

---

# 1️⃣ Helm Ownership Conflict

## ❌ Error


Service "java-maven-app-service" exists and cannot be imported into the current release
invalid ownership metadata


## 🔎 Cause

The application was initially deployed using raw Kubernetes manifests:


kubectl apply -f k8s/


When migrating to Helm, existing Kubernetes resources were not created by Helm and therefore lacked Helm ownership labels and annotations.

Helm refused to "adopt" them.

## ✅ Resolution

Deleted existing resources in the namespace:

```bash
kubectl delete all --all -n test
kubectl delete ingress --all -n test
kubectl delete hpa --all -n test

Reinstalled the Helm release:

helm upgrade --install java-app-maven helm/java-maven-app -n test
2️⃣ Jenkins: helm: not found
❌ Error
helm: not found
🔎 Cause

Jenkins was running inside a Docker container that did not have Helm installed.

Although Helm was installed on the droplet host, it was not available inside the Jenkins container environment.

✅ Resolution

Created a custom Jenkins Docker image including:

Helm

kubectl

curl

git

Rebuilt and restarted Jenkins using the new image.

Verified:

helm version
kubectl version --client
3️⃣ Spring Boot Whitelabel 404 Error
❌ Error
Whitelabel Error Page
There was an unexpected error (type=Not Found, status=404)
🔎 Cause

The application did not expose a root (/) mapping.

Ingress and Service were working correctly, but the application endpoint did not match the requested path.

✅ Resolution

Confirmed controller mappings in:

src/main/java/...

Verified index.html was correctly placed in:

src/main/resources/

Rebuilt image and redeployed.

4️⃣ Ingress HTTP → HTTPS Port Error
❌ Error
400 Bad Request
The plain HTTP request was sent to HTTPS port
🔎 Cause

Ingress controller was configured to expect HTTPS traffic while requests were sent over HTTP.

✅ Resolution

Adjusted Ingress configuration to use correct service port and protocol.

Ensured correct port mapping from:

NodePort

Ingress service

Application container port

5️⃣ Helm Template Indentation Errors
❌ Error

Helm lint failing around imagePullSecrets indentation.

🔎 Cause

Improper YAML indentation when using:

{{ toYaml .Values.imagePullSecrets | indent 8 }}

Helm templates are whitespace-sensitive.

✅ Resolution

Updated to:

{{- with .Values.imagePullSecrets }}
imagePullSecrets:
{{ toYaml . | nindent 8 }}
{{- end }}

Revalidated with:

helm lint helm/java-maven-app


6️⃣ HPA Not Scaling
❌ Issue

Horizontal Pod Autoscaler not reacting.

🔎 Cause

Metrics Server was not installed in the cluster.

HPA requires metrics API to fetch CPU usage.

✅ Resolution

Installed Metrics Server in the cluster.

Verified:

kubectl top pods

HPA started functioning correctly.

7️⃣ Jenkins Environment Variable Interpolation Issue
❌ Issue

Helm values not correctly passed when using $VARIABLE inside triple-quoted strings.

🔎 Cause

Groovy interpolation vs shell variable expansion conflict.

✅ Resolution

Used:

${VARIABLE}

instead of:

$VARIABLE

inside Jenkins sh """ """ blocks.

🎯 Lessons Learned

Helm does not adopt existing Kubernetes resources automatically.

Jenkins container environment must include required CLI tools.

Ingress debugging requires checking ports and protocols carefully.

Helm template indentation is critical.

HPA requires Metrics Server.

Immutable image tagging avoids deployment confusion.

🚀 Key Takeaway

This project demonstrates not just deployment, but real-world troubleshooting across:

Docker

Jenkins

Helm

Kubernetes networking

Autoscaling

Bare-metal cluster limitations