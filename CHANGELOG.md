# Changelog

## [Feature/tomcat-k8s-deployment] - 2025-07-14
### Added
- Kubernetes deployment project for Tomcat.
- Documentation updates in `README.md` for Tomcat deployment in Kubernetes.

---

## [Feature/helm-charts] - 2025-03-10
### Added
- ELK Helm chart (initial version and iterative revisions).
- Helm chart for Tomcat deployment.
- Newest manifests for monitoring.
- Updated Tomcat deployment manifests.
- Documentation updates in `README.md`.

### Fixed
- Multiple incremental fixes for issues (1a–2c).
- Adjustments to deployment and manifest files for stability.

---

## [Feature/cicd-deployment] - 2025-03-05
### Added
- Full CI/CD pipeline using Jenkins and ArgoCD.
- Stages for WAR generation, Docker image build, MinIO upload, and Kubernetes deployment.
- Nexus integration for WAR download during CD stage.
- ArgoCD synchronization steps across multiple iterations.
- Trivy scan integration for Docker images in build pipeline.
- Checkov linting of Dockerfiles and security issue resolution.
- ArgoCD configuration for DuckDNS domain.
- Annotations for ArgoCD applications.
- Updated documentation in `README.md`.

### Changed
- Refined Jenkinsfile across multiple iterations with new stages, debugging improvements, and fixes.
- Adjusted Docker build paths and artifact variable usage.
- Integrated MinIO and Nexus credential handling.

### Fixed
- Errors in deployment pipeline stages.
- Security issues flagged by Checkov.
- Dockerfile issues with build context.
- Multiple bugs during CD deployment stages.

---

## [Fix/lab-deploy] - 2025-02-15
### Added
- Jenkinsfile for Tomcat deployment pipeline.

### Changed
- Adjusted Tomcat ports for lab deployment.
- Updated pipeline to deploy latest WAR artifacts.

---

## [Initial Release] - 2025-02-01
### Added
- Initial deployment files for Docker-based setup.

