# Terraform-Managed Azure Subscription Baseline

## 1. Project Overview

This project manages Azure subscription-level guardrails using Terraform.

The main goal is to define Azure governance controls as Infrastructure as Code instead of configuring them manually through the Azure Portal.

The project demonstrates two important use cases:

1. Provision subscription guardrails from code.
2. Detect configuration drift caused by manual changes in the Azure Portal.

The project also uses Azure Blob Storage as a remote Terraform backend to provide centralized state storage and state locking.

---

## 2. Problem Statement

Azure subscription governance is often configured manually through the Azure Portal.

This can create problems such as:

- Inconsistent configuration
- Manual configuration errors
- Difficulty tracking changes
- Configuration drift
- Problems when multiple contributors work with Terraform state

This project addresses these problems by managing subscription guardrails through Terraform and using remote state storage.

---

## 3. Objectives

The project aims to:

- Manage Azure subscription policies using Terraform.
- Enforce required resource tagging.
- Detect manual changes made outside Terraform.
- Store Terraform state remotely in Azure Blob Storage.
- Use Terraform state locking to protect concurrent operations.
- Maintain infrastructure configuration as code.
- Provide a reproducible GitHub-based project.

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
              |                  + State Lock
              v
      Subscription Policy
              |
              v
       Resource Guardrail
              |
              v
      Manual Portal Change
              |
              v
       Terraform Plan
              |
              v
        Drift Detection