<h3 align="center">
  <a name="title"></a>
  <img src="./assets/logo.png" alt="Project Logo">
  <br>
  terraform module for dataform, with best practices baked in.
  <br>
</h3>

---

<p align="center">
  Built with:
  <br>
  <img src="https://img.shields.io/badge/GitHub_Actions-2088FF?logo=github-actions&logoColor=white" alt="GitHubActions">
  <img src="https://img.shields.io/badge/Git-F05032?logo=git&logoColor=fff" alt="Git">
  <img src="https://img.shields.io/badge/GitHub-%23121011.svg?logo=github&logoColor=white)" alt="GitHub">
  <br>
  <img src="https://img.shields.io/badge/JavaScript-F7DF1E?logo=javascript&logoColor=000" alt="JavaScript">
  <img src="https://img.shields.io/badge/Neovim-57A143?logo=neovim&logoColor=fff" alt="NeoVim">
  <img src="https://img.shields.io/badge/Google%20Cloud-%234285F4.svg?logo=google-cloud&logoColor=white" alt="GoogleCloud">
  <br>
  <img src="https://img.shields.io/badge/Terraform-7B42BC?&logo=terraform&logoColor=white" alt="Terraform">
  <img src="https://img.shields.io/badge/Markdown-000000?logo=markdown&logoColor=fff" alt="Markdown">
</p>

<img src="./assets/overview.png" alt="overview" width="400"/>
<a name="overview"></a>
<p>

This repository provides a comprehensive approach to setting up and managing Dataform on Google Cloud Platform (GCP) using Terraform. It leverages the power of Terraform to automate the provisioning of infrastructure and resources required for Dataform, ensuring consistency, repeatability, and ease of management.

#### contents

- [dataform-terraform](#title)
  - [overview](#overview)
  - [requirements](#requirements)
  - [structure](#structure)
  - [terraform](#terraform)
  - [best](#best)
  - [resources](#resources)
  - [authors](#authors)

---

<img src="./assets/requirements.png" alt="overview" width="400"/>
<a name="requirements"></a>
<p>

1. **Create a Google Cloud Project:**
   - Navigate to the [Google Cloud Console](https://console.cloud.google.com/).
   - Create a project - [Create a Project](https://cloud.google.com/resource-manager/docs/creating-managing-projects).
   - Enable billing for your project - [Enable Billing](https://cloud.google.com/billing/docs/how-to/modify-project#enable_billing_for_a_new_project).
2. **Set Up a Git Repository:**
    - Create a Git repository (e.g., on GitHub, Bitbucket) to store your Dataform code. This repository will be linked to your Dataform repository on GCP.
3. **Generate SSH Keys:**
    - Generate a public-private SSH key pair that you'll use to connect your Dataform repository to the Git repository: [Generate SSH Keys](https://help.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent).
4. **Install Terraform:** Download and install Terraform on your local machine: [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli).
5. **Install Google Cloud SDK:** Install the Google Cloud SDK to manage your GCP resources: [Install Google Cloud SDK](https://cloud.google.com/sdk/docs).
6. **Authenticate with Google Cloud:** Authenticate your Google Cloud account using the Google Cloud SDK: [Authenticate with Google Cloud](https://cloud.google.com/sdk/docs/authorizing).

---

<img src="./assets/structure.png" alt="overview" width="400"/>
<a name="structure"></a>
<p>

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

---

<img src="./assets/terraform.png" alt="overview" width="400"/>
<a name="terraform"></a>
<p>

1. Configure Terraform
   - Copy one of the examples, being sure to use your own workflows/configs in the ./configs folder.
   - Configure your Terraform backend in a `backend.tf` if required.
2. Initialise Terraform
   - Run `terraform init` to initialise Terraform and download the necessary providers.
3. Plan Terraform Changes
   - Run `terraform plan` to review the infrastructure changes that Terraform will apply.
4. **Apply Terraform Changes:**
   - Run `terraform apply` to apply the changes to your GCP environment.
5. **Update your SSH Key:**
   - Add the SSH Key you Generated in place of the placeholder Secret Terraform Created.

<!-- BEGIN_TF_DOCS -->

#### requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.7.4 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 6.11.2, < 7.0.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | >= 6.11.2, < 7.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.1.0, < 4.0.0 |
| <a name="requirement_http"></a> [random](#requirement\http) | >= 3.1.0, < 4.0.0 |

#### providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 6.11.2, < 7.0.0 |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | >= 6.11.2, < 7.0.0 |
| <a name="provider_http"></a> [http](#provider\_http) | >= 3.1.0, < 4.0.0|
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.1.0, < 4.0.0 |

#### modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dataform-sa"></a> [dataform-sa](#module\_dataform-sa) | github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/iam-service-account | v36.0.1 |
| <a name="module_dataform-ssh-key"></a> [dataform-ssh-key](#module\_dataform-ssh-key) | github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/secret-manager | v36.0.1 |
| <a name="module_project"></a> [project](#module\_project) | github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/project | v36.0.1 |

#### resources

| Name | Type |
|------|------|
| [google-beta_google_dataform_repository.dataform_respository](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_dataform_repository) | resource |
| [google-beta_google_dataform_repository_release_config.release_config](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_dataform_repository_release_config) | resource |
| [google-beta_google_dataform_repository_workflow_config.workflow_config](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_dataform_repository_workflow_config) | resource |
| [random_uuid.check](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [google_client_config.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) | data source |
| [http_http.bitbucket](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |
| [http_http.github](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |
| [http_http.workspace](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

#### inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_base_dir"></a> [base\_dir](#input\_base\_dir) | The base directory for the dataform project | `string` | `"workflows"` | no |
| <a name="input_default_branch_name"></a> [default\_branch\_name](#input\_default\_branch\_name) | The default branch name for the repository | `string` | `"main"` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | labels to apply to all resources | `map(string)` | <pre>{<br/>  "iac": "terraform"<br/>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the dataform repository | `string` | `"dataform"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project id | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region where the project will be created | `string` | n/a | yes |
| <a name="input_repository_url"></a> [repository\_url](#input\_repository\_url) | The repository url for dataform | `string` | n/a | yes |
| <a name="input_vcs"></a> [vcs](#input\_vcs) | The vcs of choice - can only be 'gihub' or 'bitbucket' | `string` | `"github"` | no |

#### outputs

| Name | Description |
|------|-------------|
| <a name="output_http"></a> [http](#output\_http) | n/a |

<!-- END_TF_DOCS -->

---

<img src="./assets/best.png" alt="overview" width="400"/>
<a name="best"></a>
<p>

- You must have a basic understanding of Terraform, Dataform, and Git to use this repository.
- The provided Terraform code is a template and may need adjustments to meet your specific requirements.

---

<img src="./assets/resources.png" alt="overview" width="400"/>
<a name="resources"></a>
<p>

- [Terraform Documentation](https://www.terraform.io/docs/index.html)
- [Terraform Registry](https://registry.terraform.io/)
- [Google Cloud BigQuery](https://cloud.google.com/bigquery/docs)
- [Google Cloud Storage](https://cloud.google.com/storage/docs)
- [Google Cloud Eventarc](https://cloud.google.com/eventarc/docs)
- [Google Cloud Workflows](https://cloud.google.com/workflows/docs)
- [Google Cloud Secret Manager](https://cloud.google.com/secret-manager/docs)

---

<img src="./assets/authors.png" alt="overview" width="400"/>
<a name="authors"></a>
<p>
  Brought to you by the incredible minds of <a href="https://github.com/EmileHofsink">Emile Hofsink</a> and <a href="https://github.com/BenjaminWestern">Benjamin Western</a>.
<div align="center">
  <table>
   <td><img src="./assets/author1.jpg" width="350"></td>
  <td><img src="./assets/author2.jpg" width="330"></td>
</table>
</div>
