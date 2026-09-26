# Terraform-Managed Azure Subscription Baseline

## 1. Project Overview

This project manages Azure subscription-level governance guardrails using Terraform.

The project demonstrates how Infrastructure as Code can be used to:

1. Provision Azure subscription guardrails from code.
2. Detect configuration drift caused by manual Azure Portal changes.
3. Store Terraform state remotely using Azure Blob Storage.
4. Use Terraform state locking for safer infrastructure operations.

---

## 2. Problem Statement

Manual Azure Portal configuration can lead to configuration drift and makes it difficult to maintain a consistent infrastructure baseline.

This project addresses these problems by defining the desired Azure governance configuration in Terraform and comparing it with the actual Azure environment.

---

## 3. Objectives

- Manage Azure Policy assignments using Terraform.
- Enforce required resource tags.
- Detect manual configuration changes.
- Remediate detected drift using Terraform.
- Store Terraform state remotely in Azure Blob Storage.
- Demonstrate Terraform state locking.
- Maintain infrastructure configuration in GitHub.

---

## 4. Architecture

```text
                    GitHub Repository
                           |
                           v
                    Terraform Code
                           |
                           v
                    Terraform CLI
                           |
              +------------+------------+
              |                         |
              v                         v
       Azure Subscription       Azure Blob Storage
              |                  Remote State
              |                  State Locking
              v
       Azure Policy Assignment
              |
              v
        Resource Guardrail
              |
       +------+------+
       |             |
       v             v
 Missing Tag     Correct Tag
       |             |
       v             v
     DENY          ALLOW

              Azure Portal
                    |
                    v
             Manual Change
                    |
                    v
             Terraform Plan
                    |
                    v
             Drift Detection
                    |
                    v
             Terraform Apply
                    |
                    v
             Drift Remediation
5. Technologies Used
Microsoft Azure
Terraform
AzureRM Terraform Provider
Azure Policy
Azure Blob Storage
Azure CLI
Git
GitHub
Windows Command Prompt
6. Project Structure
Terraform-Azure-Subscription-Baseline/
│
├── bootstrap/
│   ├── main.tf
│   ├── providers.tf
│   ├── variables.tf
│   ├── versions.tf
│   └── .terraform.lock.hcl
│
├── terraform/
│   ├── backend.tf
│   ├── policy_assignments.tf
│   ├── providers.tf
│   ├── variables.tf
│   ├── versions.tf
│   └── .terraform.lock.hcl
│
├── .gitignore
└── README.md
7. Azure Policy Guardrail

The main Terraform configuration creates the following subscription-level policy assignment:

Terraform - Require Project Tag

The policy requires resources to contain:

Project = TerraformBaseline

The project uses the Azure built-in policy:

Require a tag and its value on resources

The policy effect is:

Deny

Therefore, resources that do not contain the required tag are rejected by Azure Policy.
8. Guardrail Testing

The guardrail was tested using an Azure Storage Account.

Test 1 — Resource without required tag

A Storage Account was attempted without the required tag.

Azure rejected the request with:

RequestDisallowedByPolicy

The policy evaluation showed:

tags[Project]
targetValue = TerraformBaseline
result = False

This demonstrates that the Terraform-managed Azure Policy prevents creation of a resource that does not satisfy the required tag.

Test 2 — Resource with required tag

A Storage Account was created with:

Project = TerraformBaseline

The resource creation succeeded with:

provisioningState = Succeeded

This demonstrates the positive case of the guardrail.
9. Drift Detection

The project also demonstrates configuration drift detection.

The workflow used was:

Terraform Configuration
        |
        v
Azure Policy Assignment
        |
        v
Manual Change in Azure Portal
        |
        v
terraform plan
        |
        v
Drift Detected

For the demonstration, the Azure Policy assignment was manually changed in the Azure Portal by adding an Audit policy effect override.

Terraform detected the difference:

- overrides {
    - value = "Audit" -> null
  }

Plan: 0 to add, 1 to change, 0 to destroy.
10. Drift Remediation

After detecting the drift, Terraform was used to restore the desired configuration.

The remediation was applied using:

terraform apply

The resulting configuration was verified using Azure CLI:

displayName     = Terraform - Require Project Tag
enforcementMode = Default
overrides       = null

This demonstrates the complete drift lifecycle:

Manual Azure Change
        |
        v
Drift
        |
        v
terraform plan
        |
        v
Drift Detected
        |
        v
terraform apply
        |
        v
Desired Configuration Restored
11. Remote Terraform State

The main Terraform configuration uses an Azure Storage Account as its remote backend.

Backend configuration:

Resource Group:
rg-terraform-state

Storage Account:
tfstatebaseline2026kg01

Container:
tfstate

State Key:
subscription-baseline.tfstate

The backend is configured in:

terraform/backend.tf
12. Terraform State Locking

Terraform uses the Azure backend for remote state management.

During Terraform operations, the CLI displayed:

Acquiring state lock...

and after the operation:

Releasing state lock...

This demonstrates that Terraform is using the remote backend and state locking mechanism.

13. Bootstrap

The bootstrap directory contains the Terraform configuration required to create the remote backend infrastructure.

It creates:

Resource Group
Azure Storage Account
Blob Container

The bootstrap configuration is kept separate because the backend must exist before the main Terraform configuration can use it.

14. Terraform Workflow
1. Login to Azure
az login
2. Set the subscription environment variable
for /f %i in ('az account show --query id -o tsv') do set ARM_SUBSCRIPTION_ID=%i
set TF_VAR_subscription_id=%ARM_SUBSCRIPTION_ID%
3. Initialize Terraform
cd terraform
terraform init
4. Format the configuration
terraform fmt
5. Validate the configuration
terraform validate
6. Create a plan
terraform plan
7. Apply the configuration
terraform apply
15. Final Verification

The final Terraform plan was executed after the guardrail and drift demonstrations.

Terraform reported:

No changes. Your infrastructure matches the configuration.

The operation also demonstrated remote state locking:

Acquiring state lock...

followed by:

Releasing state lock...

This confirms that the final Azure infrastructure matches the Terraform configuration.

16. Main Use Cases
Use Case 1 — Provision Subscription Guardrails from Code

Terraform defines and provisions the Azure Policy assignment at subscription scope.

This makes the governance configuration reproducible and version controlled.

Use Case 2 — Track Drift from Manual Portal Changes

Changes made manually through the Azure Portal can be detected by running:

terraform plan

Terraform identifies differences between the desired configuration and the actual Azure configuration.

17. Repository and Version Control

The project is maintained using Git and GitHub.

The repository contains the Terraform source code, bootstrap configuration, provider lock files, .gitignore, and project documentation.

Terraform state files, working directories, and generated plan files are excluded from the repository.

18. Testing Summary
Test	Result
Terraform policy deployment	Passed
Resource without required tag	Denied
Resource with required tag	Allowed
Manual Azure policy change	Detected
Drift remediation	Passed
Remote Terraform state	Passed
State locking	Passed
Final Terraform plan	No changes
19. Future Improvements

Possible future improvements include:

Automated Terraform plan checks through CI/CD.
Additional Azure subscription guardrails.
Automated policy testing.
Automated drift monitoring.
Improved backend security and access controls.
Pull-request based infrastructure workflows.
20. Conclusion

This project demonstrates how Terraform can be used to manage Azure subscription governance as Infrastructure as Code.

The project provisions an Azure Policy guardrail, verifies its enforcement, detects manual configuration drift, restores the desired configuration, and uses Azure Blob Storage for remote Terraform state and state locking.

The complete project is maintained in GitHub and can be demonstrated using Terraform CLI, Azure CLI, and the Azure Portal.