# End-to-End GitOps CI/CD Pipeline with ArgoCD and EKS

This project demonstrates a fully automated, cloud-native CI/CD pipeline built on the principles of GitOps. It provisions a production-grade Kubernetes cluster on AWS (EKS), deploys a microservice application, and manages the entire lifecycle using modern DevOps tools like ArgoCD, Helm, and Terraform.

The core principle is that **Git is the single source of truth**. All infrastructure and application configuration is declared in Git, and ArgoCD ensures the live state of the cluster converges to match the state of the repository.


_Replace this with a screenshot of your own ArgoCD dashboard showing the Healthy & Synced applications._

---

## 🏛️ Architecture

The project follows a robust GitOps workflow:

1.  **Infrastructure as Code (IaC):** [Terraform](https://www.terraform.io/) is used to provision all the necessary AWS infrastructure, including the VPC, EKS Cluster, and ECR repository.
2.  **Git Repositories:** Two separate Git repositories are used to maintain a clean separation of concerns:
    *   `app-source-code`: Contains the Python Flask application source code and Dockerfile.
    *   `gitops-manifests`: Contains the Kubernetes manifests (managed by Helm) and ArgoCD application definitions. This repository is the "single source of truth."
3.  **Continuous Integration (CI):** A [GitHub Actions](https'://github.com/features/actions') workflow is triggered on every push to the `app-source-code` repository. This pipeline:
    *   Builds a new Docker image.
    *   Pushes the image to Amazon ECR with a unique tag (the Git commit SHA).
    *   Automatically updates the application's image tag in the `gitops-manifests` repository.
4.  **Continuous Deployment (CD):** [ArgoCD](https://argo-cd.readthedocs.io/en/stable/) runs in the EKS cluster and continuously monitors the `gitops-manifests` repository.
    *   When it detects a change (the new image tag), it automatically pulls the updated manifests.
    *   It applies the changes to the cluster, triggering a rolling update of the application.
5.  **Secret Management:** Secrets are managed securely using [AWS Secrets Manager](https://aws.amazon.com/secrets-manager/) and the [External Secrets Operator (ESO)](https://external-secrets.io/). Secrets are never stored in Git.


_This is a generic diagram. Feel free to create your own for a more personal touch!_

---

## ✨ Key Features & Technologies

*   **Kubernetes:** [Amazon EKS (Elastic Kubernetes Service)](https://aws.amazon.com/eks/) for a managed, production-ready Kubernetes control plane.
*   **GitOps:** [ArgoCD](https://argo-cd.readthedocs.io/en/stable/) for implementing the Git-as-a-source-of-truth deployment strategy.
*   **Infrastructure as Code:** [Terraform](https://www.terraform.io/) for automated and repeatable infrastructure provisioning.
*   **Containerization:** [Docker](https://www.docker.com/) for packaging the application and its dependencies.
*   **Container Registry:** [Amazon ECR (Elastic Container Registry)](https://aws.amazon.com/ecr/) for secure Docker image storage.
*   **CI/CD:** [GitHub Actions](https://github.com/features/actions) for building the CI pipeline.
*   **Manifest Management:** [Helm](https://helm.sh/) for templating and managing Kubernetes manifests.
*   **Secret Management:** [AWS Secrets Manager](https://aws.amazon.com/secrets-manager/) & [External Secrets Operator](https://external-secrets.io/) for secure handling of sensitive data.
*   **Deployment Strategy (Bonus):** [Argo Rollouts](https://argoproj.github.io/rollouts/) for advanced canary deployments.

---

## 🚀 Getting Started

### Prerequisites

*   An [AWS Account](https://aws.amazon.com/free/) with programmatic access (AWS CLI configured).
*   [Terraform](https://developer.hashicorp.com/terraform/downloads) (`>=1.0`).
*   [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) installed.
*   [Helm](https://helm.sh/docs/intro/install/) installed.
*   A [GitHub Account](https://github.com/) and a Personal Access Token (PAT) with `repo` scope.
*   [Docker](https://www.docker.com/products/docker-desktop/) installed and running locally.


### Step-by-Step Instructions

1.  **Provision the Infrastructure:**
    *   Clone this repository and navigate to the `terraform` directory.
    *   Initialize Terraform: `terraform init`
    *   Review the plan: `terraform plan`
    *   Apply the infrastructure: `terraform apply --auto-approve` (This will take ~15-20 minutes).
    *   Configure `kubectl` to connect to your new cluster:
        ```bash
        aws eks --region $(terraform output -raw aws_region) update-kubeconfig --name $(terraform output -raw cluster_name)
        ```

2.  **Install and Configure ArgoCD:**
    *   Install ArgoCD using the Helm chart as described in the official documentation or the project guide.
    *   Port-forward to access the UI: `kubectl port-forward svc/argocd-server -n argocd 8080:443`
    *   Log in to the UI at `https://localhost:8080` with the `admin` user and the auto-generated password.
    *   In the ArgoCD UI, connect your `gitops-manifests` repository using the GitHub PAT you created.

3.  **Bootstrap the Application:**
    *   Apply the root "App of Apps" manifest to kickstart the GitOps process. This is the only manual `kubectl apply` needed for applications.
        ```bash
        kubectl apply -f argo-cd/app-of-apps.yaml
        ```
    *   ArgoCD will now automatically detect and deploy the `guestbook` application.

4.  **Set up the CI Pipeline:**
    *   In the `app-source-code` repository, configure the required GitHub Actions secrets:
        *   `AWS_REGION`: Your AWS region (e.g., `us-east-1`).
        *   `AWS_IAM_ROLE_TO_ASSUME`: The ARN of the IAM role for GitHub Actions created by Terraform.
        *   `ECR_REPOSITORY_NAME`: The name of the ECR repository (`guestbook-repo`).
        *   `GITOPS_PAT`: The GitHub PAT with `repo` scope.
    *   Push a change to the `app-source-code` repository to trigger the CI/CD pipeline.

5.  **Observe and Verify:**
    *   Watch the GitHub Actions pipeline build the image and update the manifests repo.
    *   Watch in the ArgoCD UI as it detects the change and deploys the new version.
    *   Access the application via the Load Balancer URL provided by the service: `kubectl get svc -n guestbook`.

---

##  Tear Down

To avoid ongoing AWS costs, destroy all the created infrastructure.

1.  Navigate to the `terraform` directory.
2.  Run the destroy command:
    ```bash
    terraform destroy --auto-approve
    ```

---

## 👤 Author

**VenkataSriHari**

*   LinkedIn: [Venkata sri Hari](https://www.linkedin.com/in/venkatasrihari/)
*   GitHub: `@Consultantsrihari`
*   Website: [TechCareerHubs](https://techcareerhubs.com/).
