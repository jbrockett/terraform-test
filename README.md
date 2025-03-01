# AWS EKS Infrastructure with Terraform

This repository contains Terraform code to deploy AWS EKS clusters with supporting infrastructure across multiple environments and regions.

## Architecture

This project creates:
- VPC with public and private subnets
- EKS cluster in [Auto Mode](https://docs.aws.amazon.com/eks/latest/userguide/automode.html)
- Nginx deployment accessible via the internet

## Directory Structure

```
├── environments/
│   ├── dev/
│   │   ├── us-east-2/
│   │   │   ├── backend.tf
│   │   │   ├── k8s-apps.tf
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   ├── terraform.tfvars
│   │   │   └── variables.tf
│   ├── prod/
│   │   ├── us-east-2/
│   │   │   ├── backend.tf
│   │   │   ├── k8s-apps.tf
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   ├── terraform.tfvars
│   │   │   └── variables.tf
├── modules/
│   ├── eks/
│   ├── k8s-apps/
│   └── vpc/
├── terraform-state-infra/
│   └── main.tf
├── devbox.json
├── devbox.lock
└── README.md
```

## Prerequisites

- [Devbox](https://www.jetpack.io/devbox/) installed
- AWS account with appropriate permissions
- AWS CLI configured with access credentials

## Getting Started

0. ** This step only needs done once to create the S3 bucket and DynamoDB table needed to store Terraform state and lock files **
   - Choose a globally unique S3 bucket name and set the value in `terraform-state-infra/main.tf`, `dev/us-east-2/backend.tf` and `prod/us-east-2/backend.tf`.
   ```
   cd terraform-state-infra
   terraform init
   terraform plan
   terraform apply
   ```

1. Clone this repository
2. Start the devbox environment (This step may be automated if your IDE has an extension for devbox, like [VSCode](https://marketplace.visualstudio.com/items?itemName=jetpack-io.devbox)):
   ```
   devbox shell
   ```
3. Navigate to the desired environment and region:
   ```
   cd environments/dev/us-east-2
   ```
4. Initialize Terraform:
   ```
   terraform init
   ```
5. Plan the deployment:
   ```
   terraform plan
   ```
6. Apply the configuration:
   ```
   terraform apply
   ```

## Accessing the Nginx Application

After deployment completes, the Nginx application will be accessible via the Network Load Balancer URL. The URL will be displayed in the Terraform outputs.

To access the Kubernetes cluster:

```bash
aws eks update-kubeconfig --region us-east-2 --name <cluster-name>
kubectl get pods -A
```

## Environment Configuration

Each environment can be customized by modifying the `terraform.tfvars` file in the respective environment directory. Key parameters include:

- `cluster_name`: Name of the EKS cluster
- `vpc_cidr`: CIDR block for the VPC

## Adding New Environments or Regions

To add a new environment or region:

1. Create a new directory under `environments/` following the existing pattern
2. Copy the Terraform files from an existing environment
3. Modify the `terraform.tfvars` file with the desired configuration

## Modules

### VPC Module

Creates a VPC with public and private subnets across multiple availability zones.

### EKS Module

Provisions an EKS cluster with auto-mode.

### k8s-apps Module

Deploys Kubernetes resources including the Nginx application.


## Troubleshooting

### Common Issues

1. **Terraform state lock**: If a deployment is interrupted, you may need to release the state lock:
   ```
   terraform force-unlock <LOCK_ID>
   ```

### Getting Help

If you encounter issues not covered here, please open an issue in the repository. 


### Future Enhancements & Improvements

1. Add GitHub Dependabot to monitor for outdated modules and open PRs when updates are required.
2. Implement terragrunt to keep your configs DRY, less boilerplate and easier maintenance.
3. Add a custom domain and SSL certificate so applications can be served via HTTPS.  Either with ACM, or within kubernetes
4. Remove application deployment and logic from a terraform repo and manage it within each application by leveraging Kubernetes tools like ArgoCD.
5. If the complexity or team size increases, moving modules to their own repo may be beneficial since they change less often and can have different authors work on modules and app teams leverage them.
6. If multi-cloud becomes needed, you can add another layer of directories at the top level for AWS, GCP, Azure, etc.  This allows for multi-cloud management with an easy to navigate hierarchy