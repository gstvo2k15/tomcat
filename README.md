# Tomcat Deployment (Docker & Kubernetes)

Repository to run Apache Tomcat locally, in Docker, or in Kubernetes. It includes Kubernetes manifests, a Jenkins CI/CD pipeline, and an example Java application (WAR).

## Repository Structure

```
.
├─ ArgoCD/                     # Argo CD application manifests
├─ docker/                     # Dockerfile and build context
├─ k8s/                        # Kubernetes manifests for Tomcat
├─ spring-boot-app-manifests/  # Additional sample manifests
├─ src/                        # Java source code to build WAR
├─ Jenkinsfile                 # Main CI/CD pipeline
├─ Jenkinsfile.beta1           # Alternate pipeline version
└─ CHANGELOG.md                # Release history
```

## Requirements

- Git
- JDK 11+ and Maven 3.8+ (to compile the WAR)
- Docker 24+
- kubectl 1.28+ with access to a cluster
- Helm 3.13+ (if using external charts)
- Argo CD 2.8+ (for GitOps deployment)
- Optional: Nexus/MinIO if replicating the CI/CD artifact flow

## Quick Start

### 1) Local WAR build

```bash
# Clone repository
git clone https://github.com/gstvo2k15/tomcat
cd tomcat

# Build WAR artifact
mvn -f src/pom.xml clean package
```

The generated WAR will be located under `src/target/`.

---

### 2) Run with Docker

```bash
# Build image
docker build -t gstvo2k15/tomcat:dev ./docker

# Run container
docker run --rm -p 8080:8080 gstvo2k15/tomcat:dev
```

Access: [http://localhost:8080](http://localhost:8080)

---

### 3) Deploy to Kubernetes (kubectl)

```bash
# Create namespace (if not existing)
kubectl create ns tomcatk8s || true

# Apply manifests
kubectl -n tomcatk8s apply -f k8s/

# Check resources
kubectl -n tomcatk8s get pods,svc,ingress
```

---

### 4) Deploy with Argo CD (GitOps)

1. Install Argo CD in your cluster.
2. Apply the manifests under `ArgoCD/` to create an `Application` resource pointing to this repository.
3. Sync the application from Argo CD UI or CLI:

```bash
argocd app sync <APP_NAME>
argocd app get <APP_NAME>
```

---

## CI/CD (Jenkins Pipeline)

The `Jenkinsfile` automates:

- WAR build using Maven
- Docker image build & push
- Trivy scan for Docker images
- Checkov lint/security for Dockerfiles & manifests
- Deployment to Kubernetes (direct or via Argo CD sync)
- Artifact management with Nexus/MinIO (optional)

Sensitive values (registry, Nexus, MinIO, Argo CD credentials) must be injected into Jenkins as credentials.

---

## Configuration

- **Ports**: Default 8080 (adjust in Kubernetes manifests if needed)
- **Image**: Update in `docker/` and manifests
- **Namespace**: Default `tomcatk8s`
- **Resources**: Set requests/limits in Deployments for production

---

## Troubleshooting

- Pod `CrashLoopBackOff`: `kubectl logs -n tomcatk8s <pod>`
- Service not reachable: check Service type and Ingress
- ImagePull errors: verify registry push & `imagePullSecrets`
- WAR not deployed: confirm WAR path in Dockerfile and manifests

---

## Development Workflow

```bash
# Local cycle
mvn -f src/pom.xml clean package
docker build -t gstvo2k15/tomcat:dev ./docker
kubectl -n tomcatk8s rollout restart deploy/<deployment-name>
```

---

## Roadmap

- Parameterize deployment via Helm/Kustomize
- Add stricter readiness/liveness probes
- Multi-environment pipelines (dev/stg/prd)

---

## Changelog

See [CHANGELOG.md](CHANGELOG.md)

---

## License

Add a `LICENSE` file if distributing publicly.

