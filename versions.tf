terraform {
  required_version = ">= 1.7.4"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.11.2, < 7.0.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 6.11.2, < 7.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.1.0, < 4.0.0"
    }
    http = {
      source  = "hashicorp/http"
      version = ">= 2.0.0, < 4.0.0"
    }
  }
}

provider "google" {
  default_labels = var.labels
  project        = var.project_id
}

provider "google-beta" {
  default_labels = var.labels
  project        = var.project_id
}
