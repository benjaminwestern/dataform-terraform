# Dataform Terraform Automation

## Description

This repository provides a comprehensive approach to setting up and managing Dataform on Google Cloud Platform (GCP) using Terraform. It leverages the power of Terraform to automate the provisioning of infrastructure and resources required for Dataform, ensuring consistency, repeatability, and ease of management.

## Table of Contents

- [Dataform Terraform Automation](#dataform-terraform-automation)
  - [Description](#description)
  - [Table of Contents](#table-of-contents)
  - [Requirements](#requirements)
    - [Google Cloud](#google-cloud)
    - [Terraform](#terraform)
    - [Development Environment](#development-environment)
  - [Important Notes](#important-notes)
  - [References](#references)
    - [Terraform](#terraform-1)
    - [Google Cloud](#google-cloud-1)
  - [Repository Structure](#repository-structure)
  - [Usage](#usage)
  - [License](#license)
  - [Authors](#authors)
  - [TODO](#todo)


## Requirements

### Google Cloud

1. **Create a Google Cloud Project:**
   - Navigate to the [Google Cloud Console](https://console.cloud.google.com/).
   - Create a project - [Create a Project](https://cloud.google.com/resource-manager/docs/creating-managing-projects).
   - Enable billing for your project - [Enable Billing](https://cloud.google.com/billing/docs/how-to/modify-project#enable_billing_for_a_new_project).
2. **Set Up a Git Repository:**
    - Create a Git repository (e.g., on GitHub, Bitbucket) to store your Dataform code. This repository will be linked to your Dataform repository on GCP.
3. **Generate SSH Keys:**
    - Generate a public-private SSH key pair that you'll use to connect your Dataform repository to the Git repository: [Generate SSH Keys](https://help.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent).

### Terraform

1. **Install Terraform:** Download and install Terraform on your local machine: [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli).

### Development Environment

1. **Install Google Cloud SDK:** Install the Google Cloud SDK to manage your GCP resources: [Install Google Cloud SDK](https://cloud.google.com/sdk/docs).
2. **Authenticate with Google Cloud:** Authenticate your Google Cloud account using the Google Cloud SDK: [Authenticate with Google Cloud](https://cloud.google.com/sdk/docs/authorizing).

## Important Notes

- You must have a basic understanding of Terraform, Dataform, and Git to use this repository.
- The provided Terraform code is a template and may need adjustments to meet your specific requirements. 
-  You will need to replace placeholders (e.g., `PROJECT_ID`, `REGION`, `REPOSITORY_URL`) with your own values in the `variables.tf` file and other configuration files.

## References

### Terraform

- [Terraform Documentation](https://www.terraform.io/docs/index.html)
- [Terraform Registry](https://registry.terraform.io/)
---
### Google Cloud

- [Google Cloud BigQuery](https://cloud.google.com/bigquery/docs)
- [Google Cloud Storage](https://cloud.google.com/storage/docs)
- [Google Cloud Eventarc](https://cloud.google.com/eventarc/docs)
- [Google Cloud Workflows](https://cloud.google.com/workflows/docs)
- [Google Cloud Secret Manager](https://cloud.google.com/secret-manager/docs)

## Repository Structure

```
.
├── gcs-trigger.tf       # Terraform configuration for Eventarc triggers.
├── backend.tf          # Terraform backend configuration.
├── main.tf             # Main Terraform configuration file.
├── workflows            # Directory containing Dataform workflow YAML files.
│   └── dataform.yaml    # Example Dataform workflow configuration.
├── variables.tf         # Terraform variables file.
└── .gitignore           # Files and directories to ignore in Git.
```

## Usage
1. Configure Terraform
   - Replace the placeholder values in the `variables.tf` file with your own project details.
   - Configure your Terraform backend in `backend.tf` if required.
2. Initialise Terraform
   - Run `terraform init` to initialise Terraform and download the necessary providers.
3. Plan Terraform Changes
   - Run `terraform plan` to review the infrastructure changes that Terraform will apply.
4. **Apply Terraform Changes:**
   - Run `terraform apply` to apply the changes to your GCP environment.
5. **Update your SSH Key:**
   - Add the SSH Key you Generated in place of the placeholder Secret Terraform Created.

## License
This repository is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Authors
- [Benjamin Western](https://benjaminwestern.io)

## TODO
- [ ] Add more detailed instructions for setting up Dataform workflows.
- [ ] Expand the Terraform configuration to include additional GCP resources.
- [ ] Improve the documentation with more detailed explanations and examples. 
