# DevOps Pirates: The Roadmap

This 3-month journey is designed to take you from a local terminal to managing a full-scale Private Cloud with automated GitOps delivery.

---

## Month 1: Foundations, Hybrid Scripting & Containers

**Objective:** Master the environment and the "code-first" mindset.

* **Week 1: Operation Pirate’s Watch.** Linux, Networking, and Nginx. Building a hybrid monitoring tool (**Bash** for system tasks + **Python** for log parsing).
* **Week 2: Collaborative Git.** Professional GitFlow, resolving conflicts, and GitHub Actions for automated linting and CI/CD.
* **Week 3: Dockerization.** Building optimized images, multi-stage builds, and private registries used in CI/CD.
* **Week 4: Micro-Services.** Orchestrating multi-container apps with Docker Compose and persistent volumes.

**Tools:** Ubuntu, Nginx, Bash, Python, Git, Docker.

---

## Month 2: Private Cloud, Storage & IaC

**Objective:** Provisioning infrastructure as code on a private cloud.

* **Week 5: The Private Cloud.** Deep dive into **OpenStack** (Nova, Neutron, Keystone). Manual provisioning via CLI.
* **Week 6: Object Storage.** Deploying **MinIO** (Local S3). Handling data persistence and bucket management.
* **Week 7: Terraform (IaC).** Automating OpenStack and MinIO provisioning. "Infrastructure as Code" starts here.
* **Week 8: Ansible.** Configuration management. Using Ansible to turn raw cloud instances into hardened, ready-to-use servers.

**Tools:** OpenStack, MinIO, Terraform, Ansible.

---

## Month 3: Orchestration, GitOps & Observability

**Objective:** Scaling with Kubernetes and automating delivery with ArgoCD.

* **Week 9: Kubernetes (K8s) Core.** Deploying clusters. Understanding Pods, Deployments, and Services and ... .
* **Week 10: Helm & Packaging.** Creating **Helm Charts** to package applications for Kubernetes.
* **Week 11: GitOps with ArgoCD.** Installing **ArgoCD** in the cluster. Implementing the "Pull" model. Syncing the cluster state with a Git repository. Automated self-healing and drift detection.
* **Week 12: Observability.** * Monitoring with **Prometheus** and **Grafana**.
* Final Showcase: A full pipeline where a Git commit triggers a Docker build, which ArgoCD then automatically deploys to K8s.

**Tools:** K8s(k3s/k0s), Helm, ArgoCD, Prometheus, Grafana.


4. **Idempotency:** Everything you build must be re-runnable without breaking.
5. **English Only:** All technical communication must be in English.
