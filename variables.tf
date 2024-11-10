variable "region" {
  description = "The region where the project will be created"
  type        = string
}

variable "project_id" {
  description = "The project id"
  type        = string
}

variable "repository_url" {
  description = "The repository url for dataform"
  type        = string
}

variable "branch_name" {
  description = "The branch name for dataform"
  type        = string
  default     = "main"
}

variable "dataform_sa_roles" {
  description = "The roles to be assigned to the dataform service account/s"
  type        = list(string)
  default = [
    "roles/bigquery.dataEditor",
    "roles/bigquery.jobUser",
    "roles/bigquery.user",
    "roles/bigquery.dataOwner"
  ]
}

variable "eventarc_sa_roles" {
  description = "The roles to be assigned to the event arc service account/s"
  type        = list(string)
  default = [
    "roles/eventarc.eventReceiver",
    "roles/workflows.invoker",
    "roles/logging.logWriter"
  ]
}
variable "workflow_sa_roles" {
  description = "The roles to be assigned to the event arc service account/s"
  type        = list(string)
  default = [
    "roles/dataform.editor",
  ]
}

variable "secret_roles" {
  description = "The roles to be assigned to the dataform service account/s"
  type        = list(string)
  default = [
    "roles/secretmanager.secretAccessor"
  ]
}

variable "apis_to_enable" {
  description = "The apis to enable"
  type        = list(string)
  default = [
    "storage.googleapis.com",
    "stackdriver.googleapis.com",
    "compute.googleapis.com",
    "dataform.googleapis.com",
    "bigquery.googleapis.com",
    "iam.googleapis.com",
    "pubsub.googleapis.com",
    "eventarc.googleapis.com",
    "workflows.googleapis.com",
    "workflowexecutions.googleapis.com",
    "logging.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "billingbudgets.googleapis.com",
    "secretmanager.googleapis.com"
  ]
}


