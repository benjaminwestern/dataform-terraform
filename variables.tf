variable "name" {
  description = "The name of the dataform repository"
  type        = string
  default     = "dataform"
}

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

variable "default_branch_name" {
  description = "The default branch name for the repository"
  type        = string
  default     = "main"
}

variable "vcs" {
  description = "The vcs of choice - can only be 'gihub' or 'bitbucket'"
  type        = string
  default     = "github"

  validation {
    condition     = var.vcs == "github" || var.vcs == "bitbucket"
    error_message = "VCS can only be 'github' or 'bitbucket'"
  }
}

variable "base_dir" {
  description = "The base directory for the dataform project"
  type        = string
  default     = "workflows"
}

variable "labels" {
  description = "labels to apply to all resources"
  type        = map(string)
  default = {
    "iac" = "terraform"
  }
}
