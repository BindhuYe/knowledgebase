# terraform-3tier-infrastructure

Terraform project to provision a secure and scalable 3-tier architecture (Web, App, DB) on AWS.  
This setup includes networking (VPC, subnets), compute resources (EC2), load balancing, and security configurations.

---

## 🏗️ Architecture Overview

This project builds the following AWS resources:

- **VPC** with public and private subnets across multiple AZs
- **Internet Gateway** for internet access
- **Route Tables** for proper routing of public and private traffic
- **Security Groups** for Web, App, and DB layers
- **EC2 Instances** in:
  - **Web Tier** (public subnet, behind ALB)
  - **App Tier** (private subnet)
  - **DB Tier** (isolated private subnet)

---

## 📁 Directory Structure
terraform-3tier-infrastructure/

├── modules/
│   ├── VPC/
│   ├── EC2/
│   ├── Security Group/
│   └── db/
├── variables.tf
├── main.tf
├── outputs.tf
└── README.md

---

## 🚀 Getting Started

### Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- AWS CLI configured with appropriate IAM permissions

### Steps

1. Clone the repo:
   ```bash
   git clone https://github.com/your-username/terraform-3tier-infrastructure.git
   cd terraform-3tier-infrastructure

2.	Initialize Terraform:
    ```bash
    terraform init

3. Review the execution plan:
    ```bash
    terraform plan

4. Apply the infrastructure:
    ```bash
    terraform apply


# 🔐 Security Considerations
	•	The database subnet does not have internet access.
	•	Security groups restrict access between tiers using specific ports.


# Cleanup
5. To destroy all infrastructure created by this project:
    ```bash
    terraform destroy


# Notes
	•	You can extend this for staging and prod by adding additional environments.
	•	Add autoscaling, RDS, and monitoring as needed.